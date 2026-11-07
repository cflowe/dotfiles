#!/usr/bin/env bash
#
#BEGIN:
#
# Usage: repo-diff.sh [-c <clone-dir>] <-r <repo-dir>>
#
#END:
#

set -eu -o pipefail

main() {
  declare clone_dir repo_dir
  declare -a files=()
  declare clone_file repo_file
  declare md5sum_c md5sum_r

  parse_args "$@"

  mapfile -t files < <(git -C "$clone_dir" --work-tree "$clone_dir" status --porcelain | awk '/^([^?]|.[^?])/ {print $NF}')

  for file in "${files[@]}"; do
    clone_file="${clone_dir}/${file}"
    repo_file="${repo_dir}/${file}"

    if [ ! -e "$clone_file" ]; then
      echo "delete clone file: '${file}'"
    elif [ ! -e "$repo_file" ]; then
      echo "new clone file: '${file}'"
    else
      md5sum_c=$(md5sum "$clone_file" | awk '{print $1}')
      md5sum_r=$(md5sum "$repo_file" | awk '{print $1}')

      if [ "$md5sum_c" != "$md5sum_r" ]; then
        echo "modified file: '${file}'"
      else
        echo "identical file: '${file}'"
      fi
    fi
  done
}

parse_args() {
  declare opt options

  options=$(getopt -o 'hc:r:' -l 'help,clone-dir:,repo-dir:' -- "$@")

  eval set -- "$options"

  while :; do
    opt=$1; shift

    case "$opt" in
    -c|--clone-dir)
      clone_dir=$1; shift
      ;;

    -r|--repo-dir)
      repo_dir=$1; shift
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

  : "${repo_dir:? No repo dir given.}"
  : "${clone_dir:=${HOME}}"
}

show_usage() {
  sed -e '0,/^#\s*BEGIN:$/d; /^#\s*END:\s*$/,$d; s/^#$//g; s/^#//g' \
    < "$0" | ${PAGER:-cat}
}

main "$@"
