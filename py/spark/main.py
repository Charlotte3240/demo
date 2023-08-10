from pyspark import SparkConf, SparkContext

conf = SparkConf().setSparkHome("demo_spark_app").setMaster("local[*]")
sc = SparkContext(conf=conf)  # spark 的入口
# sc.setLogLevel("ALL")
print(sc.version)

rdd = sc.parallelize('charlotte')

print(rdd.collect())

rdd = sc.textFile("../class.py")
print(rdd.collect())

rdd = sc.parallelize([1, 2, 3, 4, 5])
# rdd2 = rdd.map(lambda item: item + 1)

def incrase(item):
    return item + 1


rdd2 = rdd.map(incrase)

print(rdd2.collect())

rdd3 = sc.parallelize([[1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5]])
rdd4 = rdd3.flatMap(lambda x: x)
print(rdd4.collect())

sc.stop()



