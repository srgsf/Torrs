FROM golang:1.22-alpine as build

ENV CGO_ENABLED=0

ADD . /build
WORKDIR /build
RUN mkdir -p data

RUN apk add --no-cache --update git
RUN version=$(git rev-parse --abbrev-ref HEAD)-$(git log -1 --format=%h)-$(date +%Y-%m-%dT%H:%M:%S) \
    && go build -ldflags "-X main.version=${version} -s -w" -o /build/torrs ./cmd/main

FROM scratch
EXPOSE 8094
COPY --from=build /build/torrs /srv/torrs
COPY --from=build /build/data /data
ADD ./views /srv/views
ENTRYPOINT ["/srv/torrs", "--db", "/data/torrents.db" ]

