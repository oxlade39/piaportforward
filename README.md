# oxlade39/piaportforward

[Private Internet Access](https://www.privateinternetaccess.com/)
[OpenVPN](https://www.privateinternetaccess.com/) client with support for port forwarding

[![](https://images.microbadger.com/badges/image/oxlade39/piaportforward.svg)](https://microbadger.com/images/oxlade39/piaportforward "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/oxlade39/piaportforward.svg)](https://microbadger.com/images/oxlade39/piaportforward "Get your own version badge on microbadger.com")

[![Docker Build Status](https://img.shields.io/docker/cloud/build/oxlade39/piaportforward.svg)](https://hub.docker.com/r/oxlade39/piaportforward)

[![GitHub last commit](https://img.shields.io/github/last-commit/oxlade39/piaportforward.svg)](https://github.com/oxlade39/piaportforward/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/oxlade39/piaportforward.svg)](https://github.com/oxlade39/piaportforward/issues)
[![GitHub issues](https://img.shields.io/github/issues/oxlade39/piaportforward.svg)](https://github.com/oxlade39/piaportforward/issues)

[![Docker Pulls](https://img.shields.io/docker/pulls/oxlade39/piaportforward.svg)](https://hub.docker.com/r/oxlade39/piaportforward)
[![Docker Stars](https://img.shields.io/docker/stars/oxlade39/piaportforward.svg)](https://hub.docker.com/r/oxlade39/piaportforward)
[![Docker Automated](https://img.shields.io/docker/cloud/automated/oxlade39/piaportforward.svg)](https://hub.docker.com/r/oxlade39/piaportforward)

## Getting Started

This docker image will connect to PIA with OpenVPN using your PIA credentials and then request a port be opened via [PIA's service](https://www.privateinternetaccess.com/helpdesk/kb/articles/how-do-i-enable-port-forwarding-on-my-vpn). Only some regions support port forwarding so make sure you select a supporting region.

### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### docker

```shell
docker run --rm --cap-add NET_ADMIN --device /dev/net/tun -e "REGION=France" -v $(pwd)/.creds:/etc/openvpn/pia/pass --name pia oxlade39/piaportforward
```

#### docker-compose

```yaml
version: '3'

networks:
    pia:
      driver: bridge
      ipam:
        config:
          - subnet: 172.20.0.0/24

services:
  pia:
    image: oxlade39/piaportforward
    container_name: pia
    environment:
      - REGION=France
    networks:
      pia:
        ipv4_address: 172.20.0.5
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    volumes:
      - /config/pia/.credentials:/etc/openvpn/pia/pass:ro
      - /config/pia:/config
    restart: unless-stopped

```

The image requires `NET_ADMIN` and `--device /dev/net/tun` to support creating the `tun` virtual interface.

#### Environment Variables

* `REGION` - specifies the PIA region to use as a connection

#### Volumes

* `/etc/openvpn/pia/pass` - Line delimited pia username and password
* `/config/*` - Files containing useful VPN connection information. Like the VPN IP, the interface and the dynamically allocated port.

#### Useful File Locations

* `/config/vpnportfw` - File containing the opened port available for port forwarding.

#### Testing

Get your externally visible IP address from a normal shell
```shell
$ wget -qO- https://ipinfo.io/ip
213.205.194.254
```

Get your externally visible IP address from a container attached to your pia instance.
```shell
$ docker run --rm --network=container:pia alpine:3.8 wget -qO- https://ipinfo.io/ip
```
If this port is different from above then the traffic is routing via the VPN.

#### Attaching other containers

To attach other containers you can use `--network=container:${piaportforward_container_name}` in docker or in docker-compose:
```yaml
my_linked_container:
  image: some/image
  container_name: my_linked_container
  network_mode: service:${piaportforward_container_name}
```

## Find Us

* [GitHub](https://github.com/oxlade39/piaportforward)

## Acknowledgments

* [www.pantz.org](https://www.pantz.org/software/openvpn/openvpn_with_private_internet_access_and_port_forwarding.html). I followed this guide and used modified, dockerized versions of the scripts listed here.
* [qdm12/private-internet-access-docker](https://github.com/oxlade39/piaportforward). I started using this but then decided to write my own supporting port forwarding.
