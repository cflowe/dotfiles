#!/usr/bin/env bash
#
# usage: list-docker-images.sh <DATE-STRING>
#
# List docker images older than <DATE-STRING>
#
# The output is formatted like:
# <image-name>:<image-tag> <date> <time> <tz-offset> <unix-epoch>
#
#
# <DATE-STRING> is the same date string understood by the -d option of the
# `date` command. Quoting is optional for <DATE-STRING> since all args
# on the command line is considered to be a part of the <DATE-STRING>
#
# To list docker images created more than 5 days ago
#    list-docker-images.sh 5 days ago
#
# To list docker images before a give date
#    list-docker-images.sh 2018-01-02 23:59:00 -0500
#
#

set -eu -o pipefail

function main {
  declare ts_since
  ts_since=$(date +%s -d"${*:?No date given}")

  echo "Listing images older than $ts_since seconds epoch" >&2

  docker image \
    ls --format='{{.Repository}}:{{.Tag}} {{.CreatedAt}}' \
    | awk '{$0 = substr($0, 0, length($0) - 4); "date +%s -d\"" $(NF - 2) " "  $(NF - 1) " " $NF "\"" | getline ts; if (ts < '"$ts_since"') {print $0, ts}}'
}

main "$@"
