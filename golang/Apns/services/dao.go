package services

import (
	"apns/db"
	"go.uber.org/zap"
)

type ApnsUser struct {
	ID          int    `gorm:"primaryKey;column:id" json:"-"`
	Env         int8   `gorm:"column:env" json:"env"`   // 0:测试环境，1:正式环境
	IDen        string `gorm:"column:iden" json:"iden"` // xxx的iPhone
	DeviceToken string `gorm:"column:deviceToken" json:"deviceToken"`
	BundleId    string `gorm:"column:bundleId" json:"bundleId"`
	UserName    string `gorm:"column:userName" json:"userName"` // 用户名称
}

// TableName get sql table name.获取数据库表名
func (m *ApnsUser) TableName() string {
	return "apns_user"
}

func Migrate() {
	err := db.GDB().AutoMigrate(&ApnsUser{})
	if err != nil {
		zap.L().Error("auto migrate fail", zap.Error(err))
	}
}

func checkUserDevice(t string) bool {
	// 先查,再插入
	var selectUser ApnsUser
	if err := db.GDB().Where("deviceToken = ?", t).Find(&selectUser).Error; err != nil {
		zap.L().Error("select token error:", zap.Error(err))
		return false
	}
	if selectUser.DeviceToken != "" {
		return true
	}
	return false
}

func insertDevice(au ApnsUser) error {
	if err := db.GDB().Create(&au).Error; err != nil {
		zap.L().Error("create user error ", zap.Error(err))
		return err
	} else {
		return nil
	}
}

func deleteDevice(t string) error {
	if err := db.GDB().Where("deviceToken =?", t).Delete(&ApnsUser{}).Error; err != nil {
		return err
	}
	zap.L().Info("deleted record ", zap.String("token", t))
	return nil
}

func allDevice(env int, bundleID string) []string {
	// all device token
	var tokens []string
	var apnsUsers []ApnsUser
	db.GDB().Where("env = ? AND bundleId = ?", env, bundleID).Find(&apnsUsers)
	for _, au := range apnsUsers {
		tokens = append(tokens, au.DeviceToken)
	}
	return tokens
}
