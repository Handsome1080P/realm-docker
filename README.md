## Auto build realm docker.Every weekend check realm update then build docker push to docker hub.

## Repo:
https://github.com/Handsome1080P/realm-docker

## Original:
https://github.com/zhboner/realm

## How to run:
```
docker run -d \
--network host \
--name realm \
-v /root/config.toml:/root/config.toml \
-e TZ=Asia/Shanghai \
zhouyut001/realm-docker
```
