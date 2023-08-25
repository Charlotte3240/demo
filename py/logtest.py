import logging
from hc_charlotte import charlotte
import interface


logging.basicConfig(
    format='%(asctime)s [%(filename)s:%(lineno)d] %(levelname)s\t%(message)s',
    level=logging.INFO,
    # filename='./log.log',
    # filemode='a'
)
logger = logging.getLogger('test')

logging.info('%s\t%s', 'hello', 'conf_key')
charlotte.foo()

