#!/usr/bin/env bash
REMOVES=$(parallel bats-job ::: "$@" | sort)

<<<"$REMOVES" xargs "$PAGER"
<<<"$REMOVES" xargs rm -f
