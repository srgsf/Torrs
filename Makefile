APP=torrs
B=$(shell git rev-parse --abbrev-ref HEAD)
BRANCH=$(subst /,-,$(B))
GITREV=$(shell git describe --abbrev=7 --always --tags)
REV=$(GITREV)-$(BRANCH)-$(shell date +%Y-%m-%dT%H:%M:%S)

docker:
	docker build -t yourok/$(APP):master --progress=plain .

dist:
	- @mkdir -p dist
	docker build -f Dockerfile.dist --progress=plain -t $(APP).bin .
	- @docker rm -f $(APP).bin 2>/dev/null || exit 0
	docker run -d --name=$(APP).bin $(APP).bin
	docker cp $(APP).bin:/artifacts dist/
	docker rm -f $(APP).bin

build-static: info
	- go run ./cmd/genpages/gen_pages.go
	- @mkdir  -p dist/views
	- @cp -r views dist
build: build-static
	- GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "-X main.version=$(REV) -s -w" -o dist/$(APP) ./cmd/main
build-dev: build-static
	- CGO_ENABLED=0 go build -ldflags "-X main.version=$(REV)" -o dist/$(APP) ./cmd/main
clean:
	- rm -rf dist


info:
	- @echo "revision $(REV)"

.PHONY: clean dist docker info
