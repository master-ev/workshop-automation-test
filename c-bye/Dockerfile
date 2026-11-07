FROM ubuntu:4.04 AS builder
RUN apt-get update && apt-get install -y gcc
WORKDIR /build
COPY bye.c .
RUN gcc bye.c -o program_bye -static
FROM alpine:latest
WORKDIR /app
COPY --from=builder /build/program_bye .
CMD ["./program_bye"]