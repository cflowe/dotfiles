#!/usr/bin/env bash

set -eu -o pipefail

#
# run.sh <image-ref> [[docker-args] [-- [mermaid-cli-args]]
#
# Examples:
#   run.sh mermaid-cli:testing \
#     -v "${PWD}:/data" \
#     -- \
#     -i diagram.mmd
#

main() {
  declare image_ref=${1:?"No mermaide docker image:tag given."}; shift
  declare -a docker_args=()

  while [ $# -gt 0 ]; do
    if [ "$1" == '--' ]; then
      shift
      break
    fi

    docker_args+=("$1")
    shift
  done

  set -x
  docker container run --rm -u "$(id -u):$(id -g)" \
    "${docker_args[@]}" \
    "$image_ref" \
    "$@"
}

main "$@"
