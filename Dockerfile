FROM alpine:latest AS builder

RUN apk add --no-cache curl tar jq xz bzip2

WORKDIR /root/download

ARG MATCH_FILE_NAME=x86_64-unknown-linux-musl
ARG API_URL=https://api.github.com/repos/zhboner/realm/releases/latest

RUN download_url=$(curl -s "$API_URL" | jq -r --arg name "$MATCH_FILE_NAME" '.assets[] | select(.name | test($name + ".*\\.(tar\\.gz|tar\\.bz2)$")) | .browser_download_url') && \
    curl -L "$download_url" -o realm.tar && \
    file_ext=$(echo "$download_url" | grep -oE 'tar\.(gz|bz2)$') && \
    if [ "$file_ext" = "tar.gz" ]; then \
        tar -xzf realm.tar -C /root/download; \
    elif [ "$file_ext" = "tar.bz2" ]; then \
        tar -xjf realm.tar -C /root/download; \
    else \
        exit 1; \
    fi && \
    rm realm.tar

FROM alpine:latest

WORKDIR /root

RUN apk add --no-cache tzdata bzip2

ENV TZ=Asia/Shanghai

COPY --from=builder /root/download/realm /root/realm

CMD ["/root/realm", "-c", "/root/config.toml"]
