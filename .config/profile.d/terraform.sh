#!/bin/bash

if [ -z "${TF_PLUGIN_CACHE_DIR:-}" ]; then
  export TF_PLUGIN_CACHE_DIR="${HOME}/.config/terraform.d/plugin-cache"
fi

if [ -z "${TF_CLI_CONFIG_FILE:-}" ]; then
  export TF_CLI_CONFIG_FILE="${HOME}/.config/terraform.rc"
fi

alias tf=terraform
alias tfa='terraform apply'
alias tfi='terraform init'
alias tfp='terraform plan'
