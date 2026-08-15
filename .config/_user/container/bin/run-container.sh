#!/usr/bin/env bash
#
#BEGIN:
# This script runs a container with the shell environment configured in
# ${XDG_CONFIG_HOME}/_user/container/home.  The home directory of the user
# inside the container must be given.
#
# Exampes:
#   # Start an interactive shell using image alpine-debug:3.23.2.
#   run-container.sh -d /root -- -it --rm alpine-debug:3.23.2
#
# Usage:
#   run-container.sh <-d <container-home-directory>> [[options] [-- [docker-container-run-options]]
#
#   [Required arguments]
#     <-d <container-home-directory>>
#
#       The full path to the home directory of the eventual shell inside the
#       container.
#
#   [Options]
#     -h|--help
#       Show this help then exit.
#
#     -n|--dry-run <true|false>
#       Show commands instead of executing them.
#
#       Default: false
#
#END:
#

set -eu -o pipefail

main() {
  declare script_dir parent_dir
  declare container_homedir
  declare dry_run
  declare -a docker_args=()
  declare -a docker_mounts=()
  declare fd pid

  parse_args "$@"

  script_dir=$(dirname "$(realpath "$0")")
  parent_dir=$(dirname "$(realpath "$script_dir")")

  #---------------------------------------------------------------------------
  exec {fd}< <(
    set -eu -o pipefail

    cd "${parent_dir}/home"
    find . -maxdepth 1 -mindepth 1 ! -name .config \
      | awk \
          -v "BASEDIR=${parent_dir}/home" \
          -v "CONTAINER_HOMEDIR=${container_homedir}" \
          '{printf "--mount\ntype=bind,src=%s/%s,dst=%s/%s\n", BASEDIR, $0, CONTAINER_HOMEDIR, $0}'
  )
  pid=$!

  mapfile -O "${#docker_mounts[@]}" -t docker_mounts <&$fd
  exec {fd}<&-
  wait "$pid"

  #---------------------------------------------------------------------------
  exec {fd}< <(
    set -eu -o pipefail

    cd "${parent_dir}/home"
    find .config -mindepth 1 -maxdepth 1 \
      | awk \
          -v "BASEDIR=${parent_dir}/home" \
          -v "CONTAINER_HOMEDIR=${container_homedir}" \
          '{printf "--mount\ntype=bind,src=%s/%s,dst=%s/%s\n", BASEDIR, $0, CONTAINER_HOMEDIR, $0}'
  )
  pid=$!

  mapfile -O "${#docker_mounts[@]}" -t docker_mounts <&$fd
  exec {fd}<&-
  wait "$pid"

  #---------------------------------------------------------------------------
  docker_mounts+=(
    --mount "type=bind,src=$(realpath "${parent_dir}/../utils/init-profile.sh"),dst=${container_homedir}/.config/_user/utils/init-profile.sh"
  )

  #---------------------------------------------------------------------------
  echodo exec docker container run \
    "${docker_mounts[@]}" \
    "${docker_args[@]}" \
    && :
}

echodo() {
  echo "$@" >&2

  if [ "$dry_run" == 'false' ]; then
    "$@"
  fi
}

parse_args() {
  declare opt options

  options=$(getopt -o 'd:hn:' -l 'dry-run:,help' -- "$@")

  eval set -- "$options"

  while :; do
    opt=$1; shift

    case "$opt" in
    -h|--help)
      show_usage | ${PAGER:-cat}
      exit
      ;;

    -d)
      container_homedir=$1; shift
      ;;

    -n|--dry-run)
      dry_run=$1; shift
      ;;

    --) break;;

    *)
      echo "Unknown option '${opt}' given." >&2
      return 1
      ;;
    esac
  done

  if [ -z "${container_homedir:-}" ]; then
    echo 'The home directory inside the container must be given.' >&2
    return 1
  fi

  case "${dry_run:=false}" in
  true|false)
    ;;

  *)
    echo "Invalid boolean given for --dry-run: '${dry_run}'." >&2
    return 1
    ;;
  esac

  docker_args+=("$@")
}

show_usage() {
  sed -e '0,/^#\s*BEGIN:$/d; /^#\s*END:\s*$/,$d; s/^#$//g; s/^#\s/ /g' < "$0"
}

main "$@"
