# Disk Monitoring with Slack Alerts (DevOps Mini Project)

## Overview
This project monitors disk usage on a Linux system using a Bash script.
It runs automatically via cron and sends real-time alerts to Slack when
disk usage crosses a defined threshold.

## Features
- Disk usage monitoring using Bash
- Automated execution using cron
- Real-time Slack alerts via Incoming Webhooks
- Secure secret handling using environment variables
- CI pipeline using GitHub Actions

## Tech Stack
- Bash
- Linux (WSL/Ubuntu)
- Cron
- Slack Webhooks
- Git & GitHub Actions

## How It Works
1. Bash script checks disk usage of root (`/`) filesystem
2. If usage exceeds threshold, script:
   - Sends alert to Slack
   - Exits with non-zero code
3. Cron runs the script every 5 minutes
4. GitHub Actions runs the script on every push

## Configuration

### Environment Variable
Set Slack webhook URL as an environment variable:
```bash
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXXX"

### Cron Job
```bash
*/5 * * * * /home/prince/devops/disk_check.sh >> /home/prince/devops/disk_check.log 2>&1
