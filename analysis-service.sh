#!/usr/bin/env bash

# Script to start / stop the AnalysisIR.py script as a cron job

if [ "$(id -u)" -ne 0 ] ; then
  echo "This script must be run as root or with sudo"
exit 1
fi

if [ -z "$1" ]; then
  echo "You must enter an argument [start] or [stop]"
  echo "Usage: sudo analysis-service.sh start|stop"
fi

if [ "$1" != "start" ] && [ "$1" != "stop" ]; then
  echo "'start' and 'stop' are the only valid arguments"
  exit 1
fi

if [ "$1" == start ]; then
  if grep -q AnalysisIR /var/spool/cron/crontabs/pi
  then
    echo 'It appears that AnalysisIR.py is already running as a cron job!'
    echo 'Aborting!'
    exit 1
  else
    echo 'Creating clean log file AnalysisIR.log'
    echo 'Adding AnalysisIR.py to cron'
    rm -f /tmp/AnalysisIR.log
    touch /tmp/AnalysisIR.log
    chmod a+rw /tmp/AnalysisIR.log
    # NOTE: The cd /home/pi is critical to get the script to run as a cron job even with the explicit paths defined.
    echo '* * * * * cd /home/pi && /usr/bin/python3 /home/pi/scouting_python/AnalysisIR.py >> /tmp/AnalysisIR.log 2>&1' >> /var/spool/cron/crontabs/pi
  fi
fi

if [ "$1" == stop ]; then
  if grep -q AnalysisIR /var/spool/cron/crontabs/pi
  then
    echo 'AnalysisIR.py is being removed from cron'
    sed -i '/AnalysisIR/d' /var/spool/cron/crontabs/pi
  else
    echo 'AnalysisIR.py is not currently in cron. Doing nothing!'
    exit 1
  fi
fi
