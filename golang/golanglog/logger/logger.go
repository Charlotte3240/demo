package logger

import (
	"github.com/natefinch/lumberjack"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"os"
	"time"
)

func init() {
	loggerSetting()
}


var Logger *zap.Logger
var Sugar *zap.SugaredLogger

func loggerSetting() {
	writerSyncer := getLogWriter()
	encoder := getEncoder()

	// file log
	fileCore :=zapcore.NewCore(encoder,writerSyncer,zapcore.DebugLevel)
	// console log
	consoleEncoder := zapcore.NewConsoleEncoder(zap.NewDevelopmentEncoderConfig())
	consoleDebugging := zapcore.Lock(os.Stdout)
	consoleCore := zapcore.NewCore(consoleEncoder,consoleDebugging,zapcore.DebugLevel)


	core := zapcore.NewTee(fileCore,consoleCore)
	logger := zap.New(core,zap.AddCaller())
	sugar := logger.Sugar()

	Logger = logger
	Sugar = sugar
}

func getEncoder() zapcore.Encoder{
	// 更改时间显示
	encodeConfig := zap.NewProductionEncoderConfig()
	encodeConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	encodeConfig.EncodeLevel = zapcore.CapitalLevelEncoder
	return zapcore.NewConsoleEncoder(encodeConfig)
	// json formatter
	//return zapcore.NewJSONEncoder(zap.NewProductionEncoderConfig())
	// console formatter
	//return zapcore.NewConsoleEncoder(zap.NewProductionEncoderConfig())
}

func getLogWriter() zapcore.WriteSyncer{
	// 使用lumberjack 切分日志
	lumberjackLogger := &lumberjack.Logger{
		Filename: "./tts.log",
		MaxSize: 500, //Mb 单位
		MaxBackups: 50,
		MaxAge: 365,
		Compress: false,
	}

	return zapcore.AddSync(lumberjackLogger)
}



func Example(){
	loggerExample()
	sugarExample()
}


// 只能结构化日志，不能进行格式化
func loggerExample() {
	Logger.Info("this is logger info log",
		zap.Int("keyInt", 2333),
		zap.String("keyString", "string value"),
		zap.Duration("keyDuration", time.Second * 3),
	)
}

// 可以格式化日志，结构化日志，速度较慢
func sugarExample() {
	m := 333
	Sugar.Info("info level log")
	Sugar.Infow("infow log",
		"count", m,
		"url", "https://www.baidu.com",
	)
	Sugar.Infof("this is a  sugar %v message", "info")

	Sugar.Error("this is an error log")
}
