FROM alpine
LABEL maintainer "Patrick D'appollonio <patrick@dappollonio.us>"

RUN apk add --no-cache bash curl file zip unzip git && \
    rm -rf /var/cache/apk/* && \
    sed -i "s|ash|bash|g" /etc/passwd
