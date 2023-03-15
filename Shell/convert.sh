#!/bin/bash

# flac 转 wav

# 检查目录是否存在
if [ ! -d "$1" ]; then
  echo "目录不存在"
  exit 1
fi

# 列出所有的FLAC文件
find "$1" -name "*.flac" | while read filename
do
  # 构建输出文件名
  output="${filename%.flac}.wav"

  # 转换文件
#   ffmpeg -i "$filename" "$output"

  # 检查转换是否成功
  if [ $? -eq 0 ]; then
    echo "成功转换: $filename"
  else
    echo "转换失败: $filename"
  fi
done
