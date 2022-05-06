#!/bin/bash

DEVHOST=192.168.56.1

sudo sysctl -w net.ipv4.conf.eth0.route_localnet=1
sudo sysctl -w net.ipv4.ip_forward=1

sudo iptables -t nat -F

sudo iptables -t nat -A OUTPUT -m addrtype --src-type LOCAL --dst-type LOCAL -p tcp --dport 9990 -j DNAT --to-destination $DEVHOST:9990
sudo iptables -t nat -A POSTROUTING -m addrtype --src-type LOCAL --dst-type UNICAST -j MASQUERADE

sudo iptables -t nat -A OUTPUT -m addrtype --src-type LOCAL --dst-type LOCAL -p tcp --dport 8080 -j DNAT --to-destination $DEVHOST:8080
sudo iptables -t nat -A POSTROUTING -m addrtype --src-type LOCAL --dst-type UNICAST -j MASQUERADE

sudo iptables -t nat -A OUTPUT -m addrtype --src-type LOCAL --dst-type LOCAL -p tcp --dport 8787 -j DNAT --to-destination $DEVHOST:8787
sudo iptables -t nat -A POSTROUTING -m addrtype --src-type LOCAL --dst-type UNICAST -j MASQUERADE

sudo iptables -t nat -L -n -v