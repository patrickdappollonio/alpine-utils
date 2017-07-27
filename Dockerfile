FROM alpine
LABEL maintainer "Patrick D'appollonio <patrick@dappollonio.us>"

RUN apk add --no-cache bash curl file && \
    rm -rf /var/cache/apk/*
