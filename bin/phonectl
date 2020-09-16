#!/bin/sh
[ -z "$1" ] && exit 1
resp=$(echo "$1" | nc -U /tmp/phonectl.sock | jq -r .response)
[ "$resp" = "null" ] && exit 0
echo "$resp"
exit 0
