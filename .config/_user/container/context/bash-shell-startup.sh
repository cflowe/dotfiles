#!/usr/bin/env bash

# shellcheck disable=SC1090
main() {
  declare file

  if [ "${_USER_CONFIG_DEBUG:-}" == 'true' ]; then
    export PS4='+\D{%FT%H:%M:%S%z}: '
    set -x
  fi

  # This assumes that one of these files sources ~/.bashrc for interactive
  # shells. If none of these files exist, then directly source ~/.bashrc.
  while :; do
    file='/etc/profile'
    if [ -r "$file" ]; then
      . "$file"
      break
    fi

    file="${HOME}/.bash_profile"
    if [ -r "$file" ]; then
      . "$file"
      break
    fi

    file="${HOME}/.bash_login"
    if [ -r "$file" ]; then
      . "$file"
      break
    fi

    file="${HOME}/.profile"
    if [ -r "$file" ]; then
      . "$file"
      break
    fi

    case $- in
    *i*)
      file="${HOME}/.bashrc"
      if [ -r "$file" ]; then
        . "$file"
      fi
      ;;
    esac

    break
  done

  file="${HOME}/.config/_user/utils/init-profile.sh"
  if [ -r "$file" ]; then
    . "$file"
  fi
}

main
unset -f main
"$@"
