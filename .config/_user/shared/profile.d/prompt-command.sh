#!/usr/bin/env bash

# A modified version of __vte_prompt_command.
__prompt_command()
{
    local dir='~';
    [ "$PWD" != "$HOME" ] && dir=${PWD##*/}
    dir="${dir//[[:cntrl:]]}";
    dir="${dir:-/}"

    printf "\033]0;%s%s@%s:%s\033\\" \
      "${_USER_TERM_TITLE:+"$_USER_TERM_TITLE "}" \
      "${USER}" "${HOSTNAME%%.*}" \
      "${dir}"
}

export PROMPT_COMMAND='__prompt_command'
