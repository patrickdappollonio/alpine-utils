FROM alpine as eget
RUN apk add --no-cache curl
RUN curl -L https://github.com/zyedidia/eget/releases/download/v1.3.3/eget-1.3.3-linux_amd64.tar.gz | tar --strip-components 1 -xz -C /usr/local/bin
RUN chmod +x /usr/local/bin/eget

FROM google/pause as pause

# ============================================================

FROM alpine as trim

# Copy eget from previous step
COPY --from=eget /usr/local/bin/eget /usr/local/bin/eget

# Copy pause from previous step
COPY --from=pause /pause /usr/local/bin/pause

# Add a handful of default applications
RUN apk add --no-cache bash curl make file zip unzip git bind-tools busybox-extras jq openssh

# Clean the apk cache
RUN rm -rf /var/cache/apk/*

# Replace the default shell with bash instead of ash
RUN sed -i "s|ash|bash|g" /etc/passwd

# Download different apps
RUN eget https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz --file helm --to /usr/local/bin
RUN eget https://github.com/chartmuseum/helm-push/releases/download/v0.10.4/helm-push_0.10.4_linux_amd64.tar.gz --file helm-cm-push --to /usr/local/bin
RUN eget https://dl.k8s.io/v1.29.1/bin/linux/amd64/kubectl --to /usr/local/bin
RUN eget https://download.docker.com/linux/static/stable/x86_64/docker-25.0.0.tgz --file docker/docker --to /usr/local/bin
RUN eget patrickdappollonio/tgen --to /usr/local/bin
RUN eget patrickdappollonio/wait-for --to /usr/local/bin
RUN eget https://github.com/roerohan/wait-for-it/releases/download/v0.2.9/wait-for-it --to /usr/local/bin && \
  chmod +x /usr/local/bin/wait-for-it

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
