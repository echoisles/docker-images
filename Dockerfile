FROM golang:1.14.13-stretch

ENV GO111MODULE=on

WORKDIR $GOPATH/src/github.com/pion/ion
COPY go1.mod  ./go.mod
RUN cd $GOPATH/src/github.com/pion/ion && go mod download

COPY pkg/ $GOPATH/src/github.com/pion/ion/pkg
COPY cmd/ $GOPATH/src/github.com/pion/ion/cmd

WORKDIR $GOPATH/src/github.com/pion/ion/cmd/sfu
# RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /sfu .

# FROM alpine:3.12.1

# RUN apk --no-cache add ca-certificates
# COPY --from=0 /sfu /usr/local/bin/sfu

# COPY configs/docker/sfu.toml /configs/sfu.toml

# ENTRYPOINT ["/usr/local/bin/sfu"]
# CMD ["-c", "/configs/sfu.toml"]
