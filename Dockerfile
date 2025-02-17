FROM alpine AS eget
RUN apk add --no-cache curl docker-cli helm kubectl
RUN curl -L https://github.com/zyedidia/eget/releases/download/v1.3.3/eget-1.3.3-linux_amd64.tar.gz | tar --strip-components 1 -xz -C /usr/local/bin
RUN chmod +x /usr/local/bin/eget

FROM gcr.io/google-containers/pause AS pause

FROM golang:1.24-alpine AS golang
RUN apk add --no-cache git openssh
RUN git clone https://github.com/roerohan/wait-for-it.git /go/src/github.com/roerohan/wait-for-it -b v0.2.14
RUN cd /go/src/github.com/roerohan/wait-for-it && go build -a -v -ldflags '-s -w -extldflags "-static"' -o /go/bin/wait-for-it

# ============================================================

FROM alpine AS trim

# Copy eget and Alpine apps from previous step
COPY --from=eget /usr/local/bin/eget /usr/local/bin/eget
COPY --from=eget /usr/bin/docker /usr/local/bin/docker
COPY --from=eget /usr/bin/helm /usr/local/bin/helm
COPY --from=eget /usr/bin/kubectl /usr/local/bin/kubectl

# Copy pause from previous step
COPY --from=pause /pause /usr/local/bin/pause

# Copy Go apps from previous step
COPY --from=golang /go/bin/wait-for-it /usr/local/bin/wait-for-it

# Add a handful of default applications
RUN apk add --no-cache bash curl make file zip unzip git bind-tools busybox-extras jq openssh

# Clean the apk cache
RUN rm -rf /var/cache/apk/*

# Replace the default shell with bash instead of ash
RUN sed -i "s|ash|bash|g" /etc/passwd

# Download different apps

# Detect OS and Architecture and set to an environment variable
RUN eget chartmuseum/helm-push --file helm-cm-push --to /usr/local/bin
RUN eget patrickdappollonio/tgen --to /usr/local/bin
RUN eget patrickdappollonio/wait-for --to /usr/local/bin

# Test if the apps were successfully installed
RUN ls -la /usr/local/bin
RUN helm version --client
RUN helm-cm-push --help
RUN kubectl version --client
RUN docker --version
RUN tgen --version
RUN wait-for --version
RUN wait-for-it -h

# Remove eget once we're done
RUN rm /usr/local/bin/eget

# Clean single layer image
FROM scratch
LABEL maintainer "Patrick D'appollonio <hey@patrickdap.com>"
COPY --from=trim / /
