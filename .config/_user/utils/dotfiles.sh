#!/usr/bin/env bash
#
#BEGIN:
#
# Examples:
#
#   # Install dotfiles from the default <repository> using the <repository>'s
#   # default branch into $HOME.
#   .config/_user/utils./dotfiles.sh install
#
#   # Same as above, but shows a dry run of the commands.
#   .config/_user/utils./dotfiles.sh -n install
#
#   # Update dotfiles in <install-dir> using the default <repository>.
#   <install-dir>/.config/_user/utils/dotfiles.sh update
#
#   # Install dotfiles into the home directory of `test_user` using the
#   # latest commit on HEAD in the current git repository.
#   .config/_user/utils./dotfiles.sh -i ~test_user -r "$(git rev-parse --show-toplevel)" install
#
# Usage:
#   dotfiles.sh <command> [[options] [-- [git-args]]
#
#   <Commands>
#     git           Runs git commands inside of an exiting <install-dir>.
#
#     help          Show this help then exit.
#
#     install       Install dotfiles from <repository> into <install-dir>.
#
#     update        Update dotfiles in <install-dir> using <repository>.
#
#   [Options]
#
#     -h|--help
#       Show this help then exit.
#
#     -b|--branch <git-branch-or-tag>
#       The default is the default branch of the git repository <repository>.
#
#     --git-dir <directory>
#       Set the path to the repository (".git" directory).
#
#       Default:  <install-dir>/.git
#
#     -i|--install-dir <install-dir>
#       The directory to clone into.
#
#       Default: $HOME
#
#     -n|--dry-run <false|true>
#       Show commands instead of executing them.
#
#       Default: false
#
#     -r|--repository <repository>
#       The git repository to clone.
#
#       Default: https://github.com/cflowe/dotfiles
#
#   [Git Args]      These args are passed as is to this script's use of git.
#
#END:
#

set -eu -o pipefail

main() {
  declare install_dir git_dir
  declare repository
  declare dry_run='false'
  declare -a git_args=()
  declare -a args=()
  declare cmd

  parse_args "$@"

  declare internal_cmd="_cmd_${cmd}"

  case "$cmd" in
  ''|-h|--help|help)
    show_usage | ${PAGER:-cat}
    ;;

  *)
    if declare -F -- "$internal_cmd" >& /dev/null; then
      "$internal_cmd" "${args[@]}"
    else
      echo "Invalid command given: '${cmd}'." >&2
      return 1
    fi
    ;;
  esac
}

_cmd_git() {
  git_wrapper "$@"
}

_cmd_install() {
  git_clone_wrapper "$repository" "$git_dir"
  git_wrapper -c advice.detachedHead= checkout
}

_cmd_update() {
  git_wrapper pull
}

git_clone_wrapper() {
  echodo git clone --bare "${git_clone_args[@]}" "$@"
}

git_wrapper() {
  echodo git "${git_args[@]}" "$@"
}

echodo() {
  echo "$@" >&2

  if [ "$dry_run" == 'false' ]; then
    "$@"
  fi
}

parse_args() {
  declare branch
  declare opt options

  options=$(getopt -o 'i:b:hn:r:' -l 'branch:,dry-run:,git-dir:,help,install-dir:,repository:,xdg-config-home:' -- "$@")

  eval set -- "$options"

  while :; do
    opt=$1; shift

    case "$opt" in
    -h|--help)
      show_usage | ${PAGER:-cat}
      exit
      ;;

    -b|--branch)
      branch=$1; shift
      ;;

    --git-dir)
      git_dir=$1; shift
      ;;

    -i|--install-dir)
      install_dir=$1; shift
      ;;

    -n|--dry-run)
      dry_run=$1; shift
      ;;

    -r|--repository)
      repository=$1; shift
      ;;

    --) break;;

    *)
      echo "Unknown option '${opt}' given." >&2
      return 1
      ;;
    esac
  done

  : "${cmd:=${1:?No command given.}}"; shift

  args+=(
    "$@"
  )

  case "$dry_run" in
  true|false)
    ;;

  *)
    echo "Invalid boolean given for --dry-run: '${dry_run}'." >&2
    return 1
    ;;
  esac

  if [ -n "${branch:-}" ]; then
    git_clone_args+=(-b "$branch")
  fi

  : "${repository:='https://github.com/cflowe/dotfiles'}"
  : "${install_dir:="$HOME"}"
  : "${git_dir:="${install_dir}/.git"}"

  git_args+=(
    "--git-dir=${git_dir}"
    "--work-tree=${install_dir}"
  )

  if [ ! -e "$git_dir" ]; then
    echodo install -dv -m 0750 "$git_dir"
  fi
}

show_usage() {
  sed -e '0,/^#\s*BEGIN:$/d; /^#\s*END:\s*$/,$d; s/^#$//g; s/^#\s/ /g' < "$0"
}

main "$@"
