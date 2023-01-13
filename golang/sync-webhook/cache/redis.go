package cache

import (
	"errors"
	"github.com/gomodule/redigo/redis"
	"log"
)

func GetValueFromRedis() (string, error) {
	conn, err := redis.Dial("tcp", "localhost:6379")
	if err != nil {
		log.Println("dial redis fail:", err)
		return "", err
	}
	replay, err := redis.Strings(conn.Do("srandmember", "simp", "1"))
	if err != nil {
		log.Println("get simp string fail", err)
		return "", err
	}
	if len(replay) > 0 {
		return replay[0], nil
	}

	return "", errors.New("not fount simp text")
}

func SetValueToRedis(key, value string) error {
	conn, err := redis.Dial("tcp", "localhost:6379")
	if err != nil {
		log.Println("dial redis fail:", err)
		return err
	}
	if _, err := conn.Do("sadd", key, value); err != nil {
		return err
	}
	return nil
}

func ClearSimp() error {
	conn, err := redis.Dial("tcp", "localhost:6379")
	if err != nil {
		log.Println("dial redis fail:", err)
		return err
	}
	if _, err := conn.Do("del", "simp"); err != nil {
		return err
	}
	return nil
}
