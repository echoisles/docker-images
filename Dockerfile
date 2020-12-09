FROM golang:1.14.13-stretch

ENV GO111MODULE=on

WORKDIR $GOPATH/src/github.com/pion/ion
COPY go.mod  ./go.mod
RUN cd $GOPATH/src/github.com/pion/ion && cat go.mod  && rm -f go.sum  && go mod download && cat go.mod

COPY pkg/ $GOPATH/src/github.com/pion/ion/pkg
COPY cmd/ $GOPATH/src/github.com/pion/ion/cmd

WORKDIR $GOPATH/src/github.com/pion/ion/cmd/sfu

# registry.cn-hangzhou.aliyuncs.com/mememe/mydocker:pionwebrtc-ion-latest-sfu-v1.1.11
# container=test1 image= && docker run -d --name ${container} --hostname ${container} ${image} ping 127.0.0.1

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /sfu .

FROM alpine:3.12.1

RUN apk --no-cache add ca-certificates
COPY --from=0 /sfu /usr/local/bin/sfu

COPY configs/docker/sfu.toml /configs/sfu.toml

ENTRYPOINT ["/usr/local/bin/sfu"]
CMD ["-c", "/configs/sfu.toml"]
