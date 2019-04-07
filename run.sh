#!/usr/bin/env bash

docker run --rm -i --cap-add NET_ADMIN --device /dev/net/tun -e REGION=France -v $(pwd)/.credentials:/etc/openvpn/pia/pass pia-openvpn-docker 
