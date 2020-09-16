#!/usr/bin/env bash
INTERFACE=${1:-$(ifconfig | grep ^e | cut -d":" -f1 | head -n1)}
echo "using interface $INTERFACE"
IPRANGE=$(ifconfig $INTERFACE | grep inet\ | cut -d" " -f6 | cut -d"." -f1-3)".1-255"
echo "scanning $IPRANGE for open ports"
CMD="sudo nmap -Pn --top-ports=10 --open $IPRANGE"
echo "running: $CMD"
$CMD
