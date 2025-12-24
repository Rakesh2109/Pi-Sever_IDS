FROM alpine:latest

RUN apk add --no-cache darkstat

EXPOSE 667

# Darkstat needs to run in foreground mode (--no-daemon) for Docker
CMD ["darkstat", "-i", "wlan0", "--no-daemon"]

