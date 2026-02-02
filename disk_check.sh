#!/bin/bash

THRESHOLD=80
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

echo "Disk usage: ${USAGE}%"

if [ "$USAGE" -ge "$THRESHOLD" ]; then
  echo "ALERT: Disk usage HIGH (>= ${THRESHOLD}%)"
  exit 1   # 👈 CI ko FAIL karne ke liye
else
  echo "OK: Disk usage normal (< ${THRESHOLD}%)"
  exit 0
fi

