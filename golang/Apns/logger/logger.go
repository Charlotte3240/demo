package logger

import (
	"net"
	"net/http"
	"net/http/httputil"
	"os"
	"runtime/debug"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/natefinch/lumberjack"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

// LoggerSetting log 日志设置
func LoggerSetting(fileName string) {
	writerSyncer := getLogWriter(fileName)
	encoder := getEncoder()

	// file log
	fileCore := zapcore.NewCore(encoder, writerSyncer, zapcore.DebugLevel)
	// console log
	consoleEncoder := zapcore.NewConsoleEncoder(zap.NewDevelopmentEncoderConfig())
	consoleDebugging := zapcore.Lock(os.Stdout)
	consoleCore := zapcore.NewCore(consoleEncoder, consoleDebugging, zapcore.DebugLevel)

	core := zapcore.NewTee(fileCore, consoleCore)
	logger := zap.New(core, zap.AddCaller())
	// 替换zap.L()的实现
	zap.ReplaceGlobals(logger)

}

func getEncoder() zapcore.Encoder {
	// 更改时间显示
	encodeConfig := zap.NewProductionEncoderConfig()
	encodeConfig.EncodeTime = zapcore.TimeEncoderOfLayout("2006-01-02 15:04:05.000") // 时间格式设置
	encodeConfig.EncodeLevel = zapcore.CapitalLevelEncoder                           // 所有level显示
	encodeConfig.EncodeDuration = zapcore.MillisDurationEncoder                      // 毫秒显示
	encodeConfig.EncodeCaller = zapcore.ShortCallerEncoder                           // 相对路径caller显示
	return zapcore.NewConsoleEncoder(encodeConfig)                                   // console 样式，还可以选择下面的json样式
	// json formatter
	//return zapcore.NewJSONEncoder(zap.NewProductionEncoderConfig())
	// console formatter
	//return zapcore.NewConsoleEncoder(zap.NewProductionEncoderConfig())
}

func getLogWriter(fileName string) zapcore.WriteSyncer {
	// 使用lumberjack 切分日志
	lumberjackLogger := &lumberjack.Logger{
		Filename:   fileName,
		MaxSize:    500, //Mb 单位
		MaxBackups: 50,
		MaxAge:     365,
		Compress:   false,
	}

	return zapcore.AddSync(lumberjackLogger)
}

// GinLogger gin 框架日志替换
func GinLogger(logger *zap.Logger) gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		path := c.Request.URL.Path
		query := c.Request.URL.RawQuery
		c.Next()

		cost := time.Since(start)
		logger.Info(path,
			zap.Int("status", c.Writer.Status()),
			zap.String("method", c.Request.Method),
			zap.String("path", path),
			zap.String("query", query),
			zap.String("ip", c.ClientIP()),
			zap.String("user-agent", c.Request.UserAgent()),
			zap.String("errors", c.Errors.ByType(gin.ErrorTypePrivate).String()),
			zap.Duration("cost", cost),
		)

	}
}

//GinRecovery recover 项目出现的panic
func GinRecovery(logger *zap.Logger, stack bool) gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				var brokenPipe bool
				if ne, ok := err.(*net.OpError); ok {
					if se, ok := ne.Err.(*os.SyscallError); ok {
						if strings.Contains(strings.ToLower(se.Error()), "broken pipe") || strings.Contains(strings.ToLower(se.Error()), "connection reset by peer") {
							brokenPipe = true
						}
					}
				}

				httpRequest, _ := httputil.DumpRequest(c.Request, false)
				if brokenPipe {
					logger.Error(c.Request.URL.Path,
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
					)
					// If the connection is dead, we can't write a status to it.
					c.Error(err.(error)) // nolint: errcheck
					c.Abort()
					return
				}

				if stack {
					logger.Error("[Recovery from panic]",
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
						zap.String("stack", string(debug.Stack())),
					)
				} else {
					logger.Error("[Recovery from panic]",
						zap.Any("error", err),
						zap.String("request", string(httpRequest)),
					)
				}
				c.AbortWithStatus(http.StatusInternalServerError)
			}
		}()
		c.Next()
	}
}

func Example() {
	// 只能结构化日志，不能进行格式化
	zap.L().Info("this is logger info log",
		zap.Int("keyInt", 2333),
		zap.String("keyString", "string value"),
		zap.Duration("keyDuration", time.Second*3),
	)

	// 可以格式化日志，结构化日志，速度较慢
	m := 333
	zap.L().Sugar().Info("info level log")
	zap.L().Sugar().Infow("infow log",
		"count", m,
		"url", "https://www.baidu.com",
	)
	zap.L().Sugar().Infof("this is a  sugar %v wsmessage", "info")

	zap.L().Sugar().Error("this is an error log")
}
