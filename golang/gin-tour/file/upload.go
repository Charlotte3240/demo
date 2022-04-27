package file

import (
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"net/http"
)

//Upload  文件上传
func Upload(c *gin.Context) {
	file, err := c.FormFile("fi")
	if err != nil {
		zap.L().Error("get file error: ", zap.Error(err))
		c.JSON(http.StatusBadRequest, gin.H{
			"msg": "not found file",
		})
		return
	}
	err = c.SaveUploadedFile(file, file.Filename)
	if err != nil {
		zap.L().Error("save file error", zap.Error(err))
		c.JSON(http.StatusBadRequest, gin.H{
			"msg": "save file error, try again!",
		})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"msg": "success",
	})
}
