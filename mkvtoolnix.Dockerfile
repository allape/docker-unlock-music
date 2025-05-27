FROM alpine:3

RUN apk add --no-cache mkvtoolnix

CMD ["mkvmerge", "--help"]

### build ###
# export docker_http_proxy=http://host.docker.internal:1080
# docker build --platform linux/amd64 --build-arg http_proxy=$docker_http_proxy --build-arg https_proxy=$docker_http_proxy -f mkvtoolnix.Dockerfile -t allape/mkvtoolnix:latest .
# docker tag allape/mkvtoolnix:latest docker-registry.lan.allape.cc/allape/mkvtoolnix:latest && docker push docker-registry.lan.allape.cc/allape/mkvtoolnix:latest

# sudo docker pull docker-registry.lan.allape.cc/allape/mkvtoolnix:latest
# sudo docker run --rm -v "$(pwd):/src" docker-registry.lan.allape.cc/allape/mkvtoolnix:latest mkvmerge --help
