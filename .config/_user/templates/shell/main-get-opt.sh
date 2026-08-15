#!/usr/bin/env bash
#
#BEGIN:
#
#END:
#

set -eu -o pipefail

main() {
  declare debug='false'
  declare -a args=()

  parse_args "$@"
}

parse_args() {
  declare arg opt options

  options=$(getopt -o 'hd:' -l 'help,debug:' -- "$@")

  eval set -- "$options"

  while :; do
    opt=$1; shift

    case "$opt" in
    -d|--debug)
      arg=$1; shift

      case "$arg" in
      true|t|1|yes|y)
        debug='true'
        ;;
      false|f|0|no|n)
        debug='false'
        ;;
      esac
      ;;

    -h|--help)
      show_usage
      exit 0
      ;;

    --)
      break
      ;;

    *)
      echo "Unknown option '${opt}' given." >&2
      return 1
      ;;
    esac
  done

  args=("$@")
}

show_usage() {
  sed -e '0,/^#\s*BEGIN:$/d; /^#\s*END:\s*$/,$d; s/^#$//g; s/^#\s/ /g' \
    < "$0" | ${PAGER:-cat}
}

main "$@"
