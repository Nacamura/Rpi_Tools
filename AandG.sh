#!/bin/bash
# LANG=ja_JP.utf8

pid=$$
logpath="./rtmp/rtmp.log"
 
outdir="."
 
if [ $# -le 1 ]; then
  echo "usage : $0 channel_name duration(minuites) [start_time] [file_name]"
  exit 1
fi
 
if [ $# -ge 2 ]; then
  channel=$1
  DURATION=`expr $2 \* 60`
fi
if [ $# -ge 3 ]; then
  START_TIME=$3
fi
PREFIX=${channel}
if [ $# -ge 4 ]; then
  PREFIX=$4
fi

# offset time
ruby wait_to.rb ${START_TIME}

date=`date '+%Y%m%d_%H%M'`
echo "rtmp record ${channel} start at ${date}" 1>>${logpath}
 
#
# rtmpdump
#

rtmpdump \
         -r "rtmpe://fms1.uniqueradio.jp" \
         --playpath "aandg2" \
         --app "?rtmp://fms-base1.mitene.ad.jp/agqr/" \
         --live \
         --stop $DURATION \
         -o "/tmp/${channel}_${date}" 2>>${logpath}
 
/usr/local/bin/ffmpeg -loglevel quiet -y -i "/tmp/${channel}_${date}" -acodec libmp3lame -ab 128k "${outdir}/${PREFIX}_${date}.mp3"
if [ $? = 0 ]; then
  rm -f "/tmp/${channel}_${date}"
fi
