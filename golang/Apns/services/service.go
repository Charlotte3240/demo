package services

import (
	"errors"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/sideshow/apns2"
	"github.com/sideshow/apns2/token"
	"go.uber.org/zap"
)

var _apnsService *ApnsService

func RegisterDevice(c *gin.Context) {
	var pUser ApnsUser
	if err := c.ShouldBindJSON(&pUser); err != nil {
		zap.L().Error("req client token bind json fail ", zap.Error(err))
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}
	zap.L().Info("receive:", zap.Any("user", pUser))
	if checkUserDevice(pUser.DeviceToken) {
		c.JSON(http.StatusOK, RegisterRes{Msg: "repeat token"})
	} else {
		err := insertDevice(pUser)
		if err != nil {
			c.JSON(http.StatusBadRequest, RegisterRes{Msg: err.Error()})
			return
		}
		c.JSON(http.StatusOK, RegisterRes{Msg: "registered"})
	}
}

func PushSingleNotification(c *gin.Context) {
	var pUser PushUser
	if err := c.ShouldBindJSON(&pUser); err != nil {
		zap.L().Error("req client token bind json fail ", zap.Error(err))
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}
	err := _apnsService.pushNotification(pUser)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}
	c.JSON(http.StatusOK, "ok")
}

func PushMultiple(c *gin.Context) {
	var mutablePush MutablePush
	if err := c.ShouldBindJSON(&mutablePush); err != nil {
		zap.L().Error("req mutable push bind json fail ", zap.Error(err))
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}
	c.JSON(http.StatusOK, "ok")

	var tokens []string
	var expiration time.Time
	if len(mutablePush.DeviceTokens) == 0 {
		tokens = allDevice(mutablePush.Env, mutablePush.BundleID)
	} else {
		tokens = mutablePush.DeviceTokens
	}
	if mutablePush.Expiration == 0 {
		expiration = time.Now().Add(time.Hour * 1)
	} else {
		expiration = time.Now().Add(time.Second * time.Duration(mutablePush.Expiration))
	}

	for _, t := range tokens {
		n := &apns2.Notification{
			ApnsID: mutablePush.ApnsID, // 唯一id 方便后面定位问题
			//CollapseID:  "", // 多条设备到达时显示最新的通知，如果设置了相同的collapseID
			DeviceToken: t,
			Topic:       mutablePush.BundleID,
			Expiration:  expiration, // 最长是4周
			//Priority:    0, // 实现优先级可以搞一个优先级队列
			Payload: mutablePush.Payload,
			//PushType: "",
		}
		_apnsService.notifications <- ChannelNotification{
			env:          mutablePush.Env,
			Notification: n,
		}
	}

}

type ApnsService struct {
	teamID        string
	keyID         string
	notifications chan ChannelNotification
	responses     chan ChannelNotificationRes

	clientPdt *apns2.Client
	clientUat *apns2.Client
}

func StartService(teamId, keyId string) {
	_apnsService = &ApnsService{
		teamID: teamId,
		keyID:  keyId,
	}
	_apnsService.start()
}

func (a *ApnsService) start() {
	// db migrate
	Migrate()

	// apns connect
	a.connectAPNS()

	// init channel
	a.notifications = make(chan ChannelNotification, 100)
	a.responses = make(chan ChannelNotificationRes, 200)

	// 开启10个worker push
	for i := 0; i < 10; i++ {
		go a.push(a.notifications, a.responses)
	}
	// 开启协程接收push 结果
	go a.pushResult()
}

func (a *ApnsService) connectAPNS() {
	authKey, err := token.AuthKeyFromFile("AuthKey_K7AYSC553X.p8")
	if err != nil {
		log.Fatal("token error:", err)
	}

	t := &token.Token{
		AuthKey: authKey,
		// KeyID from developer account (Certificates, Identifiers & Profiles -> Keys)
		KeyID: a.keyID,
		// TeamID from developer account (View Account -> Membership)
		TeamID: a.teamID,
	}

	a.clientUat = apns2.NewTokenClient(t)
	a.clientPdt = apns2.NewTokenClient(t)

}

// push work 方法
func (a *ApnsService) push(notifications <-chan ChannelNotification, responses chan<- ChannelNotificationRes) {
	for n := range notifications {
		var client *apns2.Client
		if n.env == 0 {
			client = a.clientUat
		} else {
			client = a.clientPdt
		}
		res, err := client.Push(n.Notification)
		if err != nil {
			zap.L().Error("push notification error: ", zap.Error(err), zap.Any("response", res))
		}
		responses <- ChannelNotificationRes{
			token:    n.DeviceToken,
			Response: res,
		}
	}

}

// pushResult 处理推送结果
func (a *ApnsService) pushResult() {
	for {
		select {
		case res := <-a.responses:
			if res.Sent() {
				zap.L().Info("Sent:", zap.String("apnsId", res.ApnsID))
			} else if res.Reason == apns2.ReasonBadDeviceToken || res.Reason == apns2.ReasonUnregistered {
				err := deleteDevice(res.token)
				if err != nil {
					zap.L().Error("del token fail", zap.Error(err))
				}
				zap.L().Info("token no effect:", zap.Any("res", res))
			} else {
				zap.L().Info("Not Sent:", zap.Any("response", res))
			}

		}
	}
}

func (a *ApnsService) pushNotification(pu PushUser) error {
	// 如果没有传deviceToken ，就发送全部设备
	// select * from apns_user where bundleId = pu.bundleId, env = pu.env, deviceToken = pu.deviceToken
	notification := &apns2.Notification{
		DeviceToken: pu.DeviceToken,
		Topic:       pu.BundleId,
		Payload:     []byte(pu.Payload),
	}
	var client *apns2.Client
	if pu.Env == 0 {
		client = a.clientUat
	} else {
		client = a.clientPdt
	}
	res, err := client.Push(notification)
	if err != nil {
		zap.L().Error("push notification error: ", zap.Error(err), zap.Any("response", res))
		return err
	}

	if res.Sent() {
		zap.L().Info("Sent:", zap.String("apnsId", res.ApnsID))
	} else if res.Reason == apns2.ReasonBadDeviceToken || res.Reason == apns2.ReasonUnregistered {
		// token无效，注销了推送服务，需要删除这条数据
		zap.L().Info("token no effect:", zap.Any("user", pu), zap.String("reason", res.Reason))
		err := deleteDevice(pu.DeviceToken)
		if err != nil {
			zap.L().Error("del token fail", zap.Error(err))
		}
		return errors.New(res.Reason)
	} else {
		zap.L().Info("Not Sent:", zap.Any("response", res))
		return errors.New(res.Reason)
	}
	return nil
}
