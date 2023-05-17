package db

import (
	"github.com/glebarez/sqlite"
	"gorm.io/gorm"
	"log"
)

var _db *gorm.DB

func init() {
	err := connectDB()
	if err != nil {
		log.Fatalln("connect db fail", err)
	}
	log.Println("db connected")
}
func connectDB() error {

	db, err := gorm.Open(sqlite.Open("./db/apns.db"), &gorm.Config{})
	if err != nil {
		return err
	}
	_db = db
	return nil
}

func GDB() *gorm.DB {
	return _db
}
