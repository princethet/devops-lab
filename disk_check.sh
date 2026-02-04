
#!/bin/bash

CI_MODE=${CI_MODE:-false}

THRESHOLD=80
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

  if [ "$CI_MODE" != "true" ]; then
    curl -4 -s -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"$MESSAGE\"}" \
      "$SLACK_WEBHOOK_URL"
    exit 1
  else
    echo "CI_MODE=true → skipping Slack alert & non-zero exit"
    exit 0
  fi
else
  echo "OK: All monitored disks below threshold."
  exit 0
fi


