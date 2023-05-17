package services

import "github.com/sideshow/apns2"

type RegisterRes struct {
	Msg string `json:"msg"`
}

type PushUser struct {
	ApnsUser
	Payload string `json:"payload"`
}

// MutablePush 推送多个设备
type MutablePush struct {
	ApnsID       string   `json:"apnsID"`
	BundleID     string   `json:"bundleId"`
	Env          int      `json:"env"`
	DeviceTokens []string `json:"deviceTokens"`
	Payload      string   `json:"payload"`
	Expiration   int64    `json:"expiration"`
}

// ChannelNotification 对*apns2.Notification 再封装一个环境变量来区分正式环境和测试环境
type ChannelNotification struct {
	env int
	*apns2.Notification
}

type ChannelNotificationRes struct {
	token string
	*apns2.Response
}
