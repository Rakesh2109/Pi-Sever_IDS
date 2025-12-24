FROM alpine:latest

RUN apk add --no-cache darkstat

EXPOSE 667

ENTRYPOINT ["darkstat"]
CMD ["-i", "wlan0"]

