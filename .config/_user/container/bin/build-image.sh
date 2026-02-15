#!/usr/bin/env bash
#
#BEGIN:
#
# Usage: build-image.sh <-r|--image-ref <image-ref>> <--base-image-repo <image-repo-slug>> <--base-image-tag <image-tag>> [[options] [-- [docker-build-args]]]
#
# Examples:
#
#   # This builds an image named 'alpine-debug:3.23.2' from the base image
#   # 'alpine:3.23.2' using dockerfile and build context:
#   #
#   #   $XDG_CONFIG_HOME/_user/container/dockerfiles/Dockerfile.default
#   #   $XDG_CONFIG_HOME/_user/container/context
#   #
#   build-image.sh \
#     -r alpine-debug:3.23.2 \
#     --base-image-repo alpine \
#     --base-image-tag 3.23.2
#
#   # Same as above but uses a local Dockerfile and the current directory as
#   # the build context.
#   build-image.sh \
#     -r alpine-debug:3.23.2 \
#     --base-image-repo alpine \
#     --base-image-tag 3.23.2 \
#     --context $PWD \
#     -- \
#     -f Dockerfile
#
#   [Required arguments]
#     <-r|--image-ref <image-ref>>
#       The name of the docker image to build.
#
#       Example: alpine-debug:3.23.2
#
#     <--base-image-repo <image-repo-slug>>
#       The image repository part of an image reference that's used as the
#       base image for this image build.
#
#       Example: alpine
#
#     <--base-image-tag <image-tag>>
#       The image tag part of an image reference that's used as the base
#       image tag for this image build.
#
#       Example: 3.23.2
#
#   [Options]
#     -h|--help
#       Show this help then exit.
#
#     -c|--context <path>
#       Defailt: $XDG_CONFIG_HOME/_user/container/context
#
#       The directory used as the image build context.
#
#     -d|--description <text>
#       Set the label 'org.opencontainers.image.description' to this value
#       if given.
#
#     -f|--file <path>
#       Defailt: $XDG_CONFIG_HOME/_user/container/dockerfiles/Dockerfile.default
#
#       The name of the Dockerfile.
#
#       Relative paths are based on:
#         $XDG_CONFIG_HOME/_user/container/dockerfiles
#
#     -n|--dry-run <true|false>
#       Show commands instead of executing them.
#
#       Default: false
#
#     -t|--timestamp <timestamp>
#       Default: The current time.
#
#       The created timestamp to use as a docker image label
#       'org.opencontainers.image.created'.
#
#       <timestamp> is converted to UTC using `date -u -d <timestamp>`.
#
#       See date(1) for the format of parsable timestamps.
#
#     -- docker-build-args
#       Any args after '--' are added as args to the `docker image build`
#       command used when bulding an image.
#
#END:
#

set -eu -o pipefail

main() {
  declare image_ref
  declare context dockerfile
  declare dry_run='false'
  declare -a docker_args=()

  declare timestamp timestamp_fmt='+%FT%TZ'

  parse_args "$@"

  cat <<EOF
"$0" "${@@Q}"

Building '${image_ref}'

EOF

  if [ "$dry_run" == 'false' ]; then
    sleep 2
  fi

  DOCKER_BUILDKIT=1 \
  echodo \
    docker image build \
      --progress=plain \
      --label org.opencontainers.image.created="${timestamp}" \
      "${docker_args[@]}" \
      --build-arg BUILDKIT_INLINE_CACHE=1 \
      "$context"
}

echodo() {
  echo "$@" >&2

  if [ "$dry_run" == 'false' ]; then
    time "$@"
  fi
}

parse_args() {
  declare opt options
  declare base_image_repo base_image_tag
  declare description=''
  #declare container_dir="${XDG_CONFIG_HOME:-"${HOME}/.config"}/_user/container"

  declare script_dir parent_dir

  script_dir=$(dirname "$(realpath "$0")")
  parent_dir=$(dirname "$(realpath "$script_dir")")

  options=$(getopt -o 'hc:d:f:n:r:t:' -l 'help,base-image-repo:,base-image-tag:,context:,description:,dry-run:,file:,image-ref:,timestamp:' -- "$@")

  eval set -- "$options"

  while :; do
    opt=$1; shift

    case "$opt" in
    -h|--help)
      show_usage | ${PAGER:-cat}
      exit 0
      ;;

    --base-image-repo)
      base_image_repo=$1; shift
      ;;

    --base-image-tag)
      base_image_tag=$1; shift
      ;;

    -c|--context)
      context=$1; shift
      ;;

    -d|--description)
      description=$1; shift
      ;;

    -n|--dry-run)
      dry_run=$1; shift
      ;;

    -f|--file)
      dockerfile=$1; shift
      ;;

    -r|--image-ref)
      image_ref=$1; shift
      ;;

    -t|--timestamp)
      timestamp=$1; shift
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

  if [ -z "${image_ref:-}" ]; then
    echo 'No docker image reference given.' >&2
    return 1
  fi

  if [ -z "${base_image_repo:-}" ]; then
    echo '--base_image_repo is required.' >&2
    return 1
  fi

  if [ -z "${base_image_tag:-}" ]; then
    echo '--base_image_tag is required.' >&2
    return 1
  fi

  case "$dry_run" in
  true|false)
    ;;

  *)
    echo "Invalid boolean given for --dry-run: '${dry_run}'." >&2
    return 1
    ;;
  esac

  docker_args+=(
    -t "$image_ref"
    --build-arg "base_image_repo=${base_image_repo}"
    --build-arg "base_image_tag=${base_image_tag}"
  )

  if [ -n "$description" ]; then
    docker_args+=(
      --label "org.opencontainers.image.description=${description}"
    )
  fi

  : "${dockerfile:="Dockerfile.alpine"}"

  if [ "${dockerfile:0:1}" != '/' ]; then
    dockerfile="${parent_dir}/dockerfiles/${dockerfile}"
  fi

  docker_args+=(
    -f "$dockerfile"
  )

  # Allow the user to override any image build args set above.
  docker_args+=("$@")

  #----------------------------------------------------------------------------
  : "${context:="${parent_dir}/context"}"

  : "${timestamp:=$(date -u "${timestamp_fmt}")}"

  # Verify the timestamp.
  date -d "$timestamp" >/dev/null
}

show_usage() {
  sed -e '0,/^#\s*BEGIN:$/d; /^#\s*END:\s*$/,$d; s/^#$//g; s/^#\s/ /g' < "$0"
}

main "$@"
