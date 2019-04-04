#!/usr/bin/env bash


docker run --rm -i --cap-add NET_ADMIN --device /dev/net/tun -v $(pwd)/.credentials:/etc/openvpn/pia/pass openvpn-docker
