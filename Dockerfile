FROM node:23 AS builder

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles

RUN test -n "$http_proxy" && echo "Acquire::http::Proxy \"$http_proxy\";" || exit 0 >> /etc/apt/apt.conf.d/10proxy.conf
RUN test -n "$https_proxy" && echo "Acquire::https::Proxy \"$https_proxy\";" || exit 0 >> /etc/apt/apt.conf.d/10proxy.conf

RUN  apt-get update && \
     apt-get install -y git && \
     rm -rf /var/lib/apt/lists/* && \
     rm -f /etc/apt/apt.conf.d/10proxy.conf

WORKDIR /build

RUN git config --global http.proxy $http_proxy && \
    git config --global https.proxy $https_proxy

RUN git clone --depth 1 https://git.unlock-music.dev/um/web.git .

RUN git config --global --unset http.proxy && \
    git config --global --unset https.proxy

ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm i --no-audit && \
    npm run build

FROM sigoden/dufs

WORKDIR /app

COPY --from=builder /build/dist /app

EXPOSE 5000

CMD ["--port", "5000", "--render-spa", "--render-index", "/app"]

### build ###
# export docker_http_proxy=http://host.docker.internal:1080
# # --platform linux/amd64
# docker build --build-arg http_proxy=$docker_http_proxy --build-arg https_proxy=$docker_http_proxy -f Dockerfile -t allape/unlock-music:latest .

# docker run -d --name unlock-music -p 8080:5000 --restart unless-stopped allape/unlock-music:latest
