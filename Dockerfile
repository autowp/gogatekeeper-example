FROM ubuntu

ENV DEBIAN_FRONTENT=non-interactive

RUN apt-get -y update && apt-get install -y curl jq
