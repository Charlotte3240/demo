# singleflight 单程

防缓存击穿

对于并发的相同请求，会合并成一个

比如 1000并发，在redis 挂了的情况下 ，打到数据库1000次请求

使用singleflight 只请求一次数据库