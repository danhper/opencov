FROM alpine:3.6

COPY deploy/_output/envconsul /envconsul
COPY deploy/_output/http/bin/http /http

EXPOSE 4000

ENTRYPOINT ["/http"]
