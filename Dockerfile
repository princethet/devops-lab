FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY disk_check.sh /app/disk_check.sh
RUN chmod +x /app/disk_check.sh

CMD ["/app/disk_check.sh"]

