#!bin/bash
for ((i=1;i<=150;i++))
do
    curl -o libjingle_peerconnection_so${i}.so https://impcdn.360-jr.com/record/sdk/v8/libjingle_peerconnection_so.so
    md5value=`md5 libjingle_peerconnection_so${i}.so`;
    echo ${md5value};
done


# for ((i=1;i<=300;i++))/
# do
#     echo ${md5 libjingle_peerconnection_so${i}.so}
# done