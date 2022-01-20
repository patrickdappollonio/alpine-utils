FROM alpine as eget
RUN apk add --no-cache curl
RUN curl -L https://github.com/zyedidia/eget/releases/download/v0.2.0/eget-0.2.0-linux_amd64.tar.gz | tar --strip-components 1 -xz -C /usr/local/bin
RUN chmod +x /usr/local/bin/eget

# ============================================================

FROM alpine as trim

# Copy eget from previous step
COPY --from=eget /usr/local/bin/eget /usr/local/bin/eget

# Add a handful of default applications
RUN apk add --no-cache bash curl file zip unzip git bind-tools busybox-extras

# Clean the apk cache
RUN rm -rf /var/cache/apk/*

# Replace the default shell with bash instead of ash
RUN sed -i "s|ash|bash|g" /etc/passwd

# Download different apps
RUN eget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz --file helm --to /usr/local/bin
RUN eget https://github.com/chartmuseum/helm-push/releases/download/v0.10.1/helm-push_0.10.1_linux_amd64.tar.gz  --file helm-cm-push --to /usr/local/bin
RUN eget https://dl.k8s.io/release/v1.22/bin/linux/amd64/kubectl --to /usr/local/bin
RUN eget patrickdappollonio/tgen --to /usr/local/bin
RUN eget patrickdappollonio/dotenv --to /usr/local/bin
RUN eget https://github.com/roerohan/wait-for-it/releases/download/v0.2.9/wait-for-it --to /usr/local/bin && \
  chmod +x /usr/local/bin/wait-for-it

# Remove eget once we're done
RUN rm /usr/local/bin/eget

# Clean single layer image
FROM scratch
LABEL maintainer "Patrick D'appollonio <patrick@dappollonio.us>"
COPY --from=trim / /
