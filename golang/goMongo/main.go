package main

import (
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"log"
	"strconv"
	"time"
)

const mongoUrl = "mongodb://localhost:27017"
const connectTimeout = time.Second * 10

const dbName = "tts"
const collectionName = "ttsCache"
const commonTimeout = time.Second * 2

func main() {
	example()
}

func example() {
	taskId := strconv.FormatInt(time.Now().UnixMilli(), 10)
	savePcm2Mongo(TTSCache{
		TaskId: taskId,
		Data:   []byte(taskId),
	})
	pcm, ok := selectPcmFromMongo(taskId)
	if ok {
		log.Println("find cache", pcm)
	} else {
		log.Println("no such document")
	}
}

type TTSCache struct {
	TaskId string
	Data   []byte
}

//selectPcmFromMongo 从mongo 查询cache
// taskId 查询id
func selectPcmFromMongo(taskId string) (pcm []byte, ok bool) {
	ctx, cancel := context.WithTimeout(context.Background(), commonTimeout)
	defer cancel()
	client, err := connectMongo(mongoUrl)
	defer disConnectMongo(client)
	if err != nil {
		return nil, false
	}
	var result = TTSCache{}
	filter := bson.D{{"taskid", taskId}}
	err = client.Database(dbName).Collection(collectionName).FindOne(ctx, filter).Decode(&result)
	if err == mongo.ErrNoDocuments {
		// 没有这个document
		return nil, false
	} else if err != nil {
		log.Println("mongo find document erorr:", err)
		return nil, false
	}
	return result.Data, true
}

//savePcm2Mongo 向mongo 中插入数据
func savePcm2Mongo(data TTSCache) {
	ctx, cancel := context.WithTimeout(context.Background(), commonTimeout)
	defer cancel()
	client, err := connectMongo(mongoUrl)
	if err != nil {
		return
	}
	result, err := client.Database(dbName).Collection(collectionName).InsertOne(ctx, data)
	if err != nil {
		log.Println("insert tts cache error:", err)
	}
	log.Println("insert tts cache success , insertId:", result.InsertedID)

	defer disConnectMongo(client)
}

//connectMongo 链接mongo
func connectMongo(url string) (*mongo.Client, error) {
	ctx, cancel := context.WithTimeout(context.Background(), connectTimeout)
	defer cancel()
	// create options
	clientOptions := options.Client().ApplyURI(url)
	// create client
	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		log.Fatalln("connect mongodb error:", err, "url:", url)
		return nil, err
	}

	// check connect
	err = client.Ping(ctx, nil)
	if err != nil {
		log.Fatalln("ping mongodb error:", err)
		return nil, err
	}
	log.Println("connected mongodb")
	return client, nil
}

func disConnectMongo(client *mongo.Client) {
	err := client.Disconnect(context.TODO())
	if err != nil {
		// error
		log.Fatalln("disconnect mongo db error:", err)
	}
	log.Println("Connection to mongo closed")
}
