#!/bin/bash

THRESHOLD=80
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$USAGE" -ge "$THRESHOLD" ]; then
  echo "ALERT: Disk usage HIGH - ${USAGE}%"
else
  echo "OK: Disk usage normal - ${USAGE}%"
fi
