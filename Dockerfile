# syntax=docker/dockerfile:1
FROM golang:alpine AS build
RUN apk --no-cache add gcc g++ make git
WORKDIR /go/src/app
COPY go.mod ./
COPY go.sum ./
COPY . .
RUN go mod download
RUN GOOS=linux go build -ldflags="-s -w" -o ./bin/web-app ./greeter_client/main.go
FROM alpine:3.9
WORKDIR /usr/bin
COPY --from=build /go/src/app/bin /go/bin
EXPOSE 5007
ENTRYPOINT /go/bin/web-app
