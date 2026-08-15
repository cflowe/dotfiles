#!/usr/bin/env bash

if type -fPp direnv &> /dev/null; then
 eval "$(direnv hook bash)"
fi
