#!/bin/bash

# exam if exist firefox and/or google chrome and shadowsocks-qt5
# if exist, kill them
# if no exist, print "No Firefox and Google Chrome"
# and reboot them

# processes need to be killed
firefox='firefox'
chrome='goolge*chrome'
ss='ss-qt5'

# kill these processes

# firefox
ps -fe|grep firefox |grep -v grep > /dev/null
if [ $? -ne 0 ]
then
    echo "start firefox process....."
    firefox &
else
    echo "firefox is runing....."
    echo "kill it ..."
    killall firefox
fi

# ss-qt5
ps -fe|grep ss-qt5 |grep -v grep > /dev/null
if [ $? -ne 0 ]
then
    echo "start firefox process....."
    ss-qt5 &
else
    echo "firefox is runing....."
    echo "kill it ..."
    killall ss-qt5
fi

# google chrome
ps -fe|grep google/chrome |grep -v grep > /dev/null
if [ $? -ne 0 ]
then
    echo "start google chrome process....."
    google-chrome-stable &
else
    echo "google chrome is runing....."
    echo "kill it ..."
    killall chrome
fi
