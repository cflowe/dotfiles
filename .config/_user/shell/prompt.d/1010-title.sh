#!/usr/bin/env bash

echo -ne "\033]0;${_USER_TERM_TITLE:+${_USER_TERM_TITLE}:}${PWD##*/}\007"
