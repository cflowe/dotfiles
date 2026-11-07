#!/usr/bin/env bash

_fn() {
  declare min_version

  if type -fPp fzf &> /dev/null; then
    min_version=$(sort -V <({ fzf --version; echo 0.47.0; }) | tail -1 | awk '{print $1}')

    if [ "$min_version" == '0.47.0' ]; then
      :
    else
      eval "$(fzf --bash)"
    fi

    if type -fPp fzf-share &> /dev/null; then
      declare fzf_share_dir
      fzf_share_dir=$(fzf-share)

      if [ -e "${fzf_share_dir}/completion.bash" ]; then
        . "${fzf_share_dir}/completion.bash"
      fi

      if [ -e "${fzf_share_dir}/key-bindings.bash" ]; then
        . "${fzf_share_dir}/key-bindings.bash"
      fi
    fi
  fi
}

_fn; unset -f _fn
