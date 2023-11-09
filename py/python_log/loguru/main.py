import traceback
from loguru import logger

logger.add("app.log", format="[{time:HH:mm:ss}] {level} - {message}")

logger.info("这是一条普通的信息日志")
logger.warning("这是一条警告日志")
logger.error("这是一条错误日志")

session = 'dasda'

try:
    1 / 0
except Exception as e:
    logger.error("Call intent model error (%s,)\n%s", session, traceback.format_exc())
