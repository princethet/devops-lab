#!/bin/bash

THRESHOLD=80
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

echo "Disk usage: ${USAGE}%"

if [ "$USAGE" -ge "$THRESHOLD" ]; then
  MESSAGE="🚨 *Disk Alert* 🚨\nHost: $(hostname)\nDisk Usage: ${USAGE}%\nThreshold: ${THRESHOLD}%\nTime: $(date)"

  curl -s -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$MESSAGE\"}" \
    "$SLACK_WEBHOOK_URL"

  echo "ALERT: Disk usage HIGH (>= ${THRESHOLD}%)"
  exit 1
else
  echo "OK: Disk usage normal (< ${THRESHOLD}%)"
  exit 0
fi
