#!/bin/bash
# LANG=ja_JP.utf8

pid=$$
playerurl="http://www3.nhk.or.jp/netradio/files/swf/rtmpe.swf"
logpath="./mplayer/mplayer.log"
 
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

#
# set channel
#
case $channel in
    "NHK1")
    rtmp="rtmpe://netradio-r1-flash.nhk.jp"
    playpath="NetRadio_R1_flash@63346"
    aspx="http://mfile.akamai.com/129931/live/reflector:46032.asx"
    ;;
    "NHK2")
    rtmp="rtmpe://netradio-r2-flash.nhk.jp"
    playpath="NetRadio_R2_flash@63342"
    aspx="http://mfile.akamai.com/129932/live/reflector:46056.asx"
    ;;
    "NHKFM")
    rtmp="rtmpe://netradio-fm-flash.nhk.jp"
    playpath="NetRadio_FM_flash@63343"
    aspx="http://mfile.akamai.com/129933/live/reflector:46051.asx"
    ;;
    *)
    echo "failed channel"
    exit 1
    ;;
esac

# offset time
ruby wait_to.rb ${START_TIME}

date=`date '+%Y%m%d_%H%M'`
echo "mplayer record ${channel} start at ${date}" 1>>${logpath}

(sleep ${DURATION};echo -n q) | \
    mplayer -playlist ${aspx} \
            -benchmark -vo null -ao pcm:file="/tmp/${channel}_${date}.wav" \
            -really-quiet -quiet

ffmpeg -loglevel quiet -y -i "/tmp/${channel}_${date}.wav" -acodec libmp3lame -ab 128k "${outdir}/${PREFIX}_${date}.mp3"
if [ $? = 0 ]; then
  rm -f "/tmp/${channel}_${date}.wav"
fi
