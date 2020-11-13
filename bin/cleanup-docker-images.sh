#!/usr/bin/env bash
#
# usage: cleanup-docker-images.sh <DATE-STRING>
#
# List docker images older than <DATE-STRING>
#
#
# <DATE-STRING> is the same date string understood by the -d option of the
# `date` command. Quoting is optional for <DATE-STRING> since all args
# on the command line is considered to be a part of the <DATE-STRING>
#
# Too clean up docker images created more than 5 days ago
#    cleanup-docker-images.sh 5 days ago
#
# Too clean up docker images before a give date
#    cleanup-docker-images.sh 2018-01-02 23:59:00 -0500
#
#

set -eu -o pipefail

function main {
  declare ts_since

  ts_since=$(set -x; date +%s -d"${*:?No date given}")

  echo "Cleaning up images older than $ts_since seconds epoch" >&2

  list-docker-images "$@" \
    | awk '{print $1}' \
    | xargs -i bash -c 'echo -n "{}: "; echo docker image rm "{}"'
}

main "$@"
