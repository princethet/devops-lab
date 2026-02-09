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
export SLACK_WEBHOOK_URL=<YOUR_SLACK_WEBHOOK_URL>
```

### Cron Job
```bash
*/5 * * * * /home/prince/devops/disk_check.sh >> /home/prince/devops/disk_check.log 2>&1
```

## Architecture
```bash
Bash Script → Cron Scheduler → Slack Alert (Webhook)
                     |
                      Log File → Logrotate


                ┌─────────────┐
                │ Cron        │
                │ Scheduler   │
                └──────┬──────┘
                       │
                ┌──────▼──────┐
                │ Bash Script │
                └──────┬──────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
┌───────▼────────┐           ┌────────▼────────┐
│ Slack Alert    │           │ Log File        │
│ (Webhook)      │           │ disk_check.log  │
└────────────────┘           └────────┬────────┘
                                      │
                                ┌─────▼──────┐
                                │ Logrotate  │
                                └────────────┘


```

## Log Rotation
Logs are managed using `logrotate` to prevent disk overuse.

Configuration:
```conf
/home/prince/devops/disk_check.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    copytruncate
}
```

## How to Run

1. Clone the repository
```bash
git clone https://github.com/princethet/devops-lab.git
cd devops-lab
```

2. Set Slack webhook
```bash
export SLACK_WEBHOOK_URL="<YOUR_SLACK_WEBHOOK_URL>"
```

3. Make script executable
```bash
chmod +x disk_check.sh
```

4. Run manually
```bash
./disk_check.sh
```

5. ADD cron Job
```bash
*/5 * * * * /home/prince/devops/disk_check.sh >> /home/prince/devops/disk_check.log 2>&1
```


## Known Limitations
Slack web UI may intermittently fail to load; webhook delivery confirmed via API(ok) and mobile app.


## Docker Usage

This project can be run inside a Docker container for portability.

### Build image
```bash
docker build -t disk-monitor .
```

### Run with slack alerts
> ⚠️ Do not commit your real Slack webhook URL..
> Use environment variables for security.

```bash
docker run --rm -e SLACK_WEBHOOK_URL="<YOUR_SLACK_WEBHOOK_URL>" disk-monitor
```


### Host Disk Monitoring (Docker Volume)

This container can monitor the host filesystem using Docker bind mounts.

```bash
docker run --rm \
  -v /:/host:ro \
  -e SLACK_WEBHOOK_URL="<YOUR_SLACK_WEBHOOK_URL>" \
  disk-monitor
```
