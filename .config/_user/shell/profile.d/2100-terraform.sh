#!/bin/bash

if [ -z "${TF_PLUGIN_CACHE_DIR:-}" ] && [ -z "${TF_CLI_CONFIG_FILE:-}" ]; then
  export TF_PLUGIN_CACHE_DIR="${HOME}/.config/_user/shell/terraform.d/plugin-cache"
  export TF_CLI_CONFIG_FILE="${HOME}/.config/_user/shell/terraform.rc"
fi

alias tf=terraform
alias tfa='terraform apply'
alias tfi='terraform init'
alias tfp='terraform plan'
