#!/bin/bash 
# 统计代码行数
find . -name "*.m" -or -name "*.h" -or -name "*.swift" -or -name "*.xib" -or -name "*.c" |xargs grep -v "^$"|wc -l

