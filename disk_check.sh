#!/bin/bash

THRESHOLD=1
MOUNTS=("/" "/home" "/var")

ALERTS=()
LOG_TS="$(date '+%Y-%m-%d %H:%M:%S')"

for M in "${MOUNTS[@]}"; do
  # Skip if mount doesn't exist
  if ! mountpoint -q "$M"; then
    echo "[$LOG_TS] INFO: $M not mounted, skipping."
    continue
  fi

  USAGE=$(df -P "$M" | tail -1 | awk '{print $5}' | sed 's/%//')
  echo "[$LOG_TS] Disk usage on $M: ${USAGE}%"

  if [ "$USAGE" -ge "$THRESHOLD" ]; then
    ALERTS+=("*$M*: ${USAGE}% (>= ${THRESHOLD}%)")
  fi
done

if [ "${#ALERTS[@]}" -gt 0 ]; then
  MESSAGE="🚨 *Disk Alert* on $(hostname)\n$(printf '%s\n' "${ALERTS[@]}")\nTime: $(date)"
  curl -s -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$MESSAGE\"}" \
    "$SLACK_WEBHOOK_URL"
  exit 1
else
  echo "[$LOG_TS] OK: All monitored disks below threshold."
  exit 0
fi

