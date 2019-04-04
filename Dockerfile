FROM alpine:3.8

RUN apk update
RUN apk add openvpn curl unzip
RUN mkdir -p /etc/openvpn/pia

WORKDIR /etc/openvpn/pia

COPY pia.conf /etc/openvpn/pia/pia.conf
COPY openvpn-route.sh /etc/openvpn/pia/openvpn-route.sh
COPY pia_port_fw.sh /etc/openvpn/pia/pia_port_fw.sh

RUN chmod 755 /etc/openvpn/pia/openvpn-route.sh && chmod 755 /etc/openvpn/pia/pia_port_fw.sh
RUN curl -o openvpn.zip https://www.privateinternetaccess.com/openvpn/openvpn.zip && unzip openvpn.zip
