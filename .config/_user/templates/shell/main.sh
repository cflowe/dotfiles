#!/usr/bin/env bash
#
#BEGIN:
#
#END:
#

set -eu -o pipefail

main() {
}

show_usage() {
  sed -e '0,/^#\s*BEGIN:$/d; /^#\s*END:\s*$/,$d; s/^#$//g; s/^#\s/ /g' \
    < "$0" | ${PAGER:-cat}
}

main "$@"
