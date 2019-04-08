FROM alpine:3.8

RUN apk update
RUN apk add openvpn curl unzip
RUN mkdir -p /etc/openvpn/pia

WORKDIR /etc/openvpn/pia

COPY pia.conf /etc/openvpn/pia/pia.conf
COPY proto.conf /etc/openvpn/pia/proto.conf
COPY pia_port_fw.sh /etc/openvpn/pia/pia_port_fw.sh
COPY forward-port.sh /etc/openvpn/pia/forward-port.sh
COPY entrypoint.sh /etc/openvpn/pia/entrypoint.sh

RUN chmod 755 /etc/openvpn/pia/pia_port_fw.sh /etc/openvpn/pia/forward-port.sh /etc/openvpn/pia/entrypoint.sh
RUN curl -o openvpn.zip https://www.privateinternetaccess.com/openvpn/openvpn.zip && unzip openvpn.zip

ENTRYPOINT ["/etc/openvpn/pia/entrypoint.sh"]
