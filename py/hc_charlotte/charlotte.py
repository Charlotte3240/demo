import logging

logger = logging.getLogger(__name__)


print(__name__)

def foo():
    s = "charlotte"
    logger.info(f"hello world {s}")
    logger.info(f"hello world %s" % s)
    logger.info(f"hello world %s", s)

