#!/usr/bin/env bash

# shellcheck disable=SC1090
if type aws-sso &> /dev/null; then
  source <(aws-sso setup completions --source)
fi
