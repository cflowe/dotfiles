#!/usr/bin/env bash
#
# Show the instance types available in one or more regions and/or zones
#
# usage: instante-types.sh [<region> [<az1>[,<az2>[,...<azN>]]]]
#
# Where <az*> is the letter of the az: i.e. 'a' for us-east-1a
#
#
# The output is a sorted csv with the format:
#   <region>,<zone>,<instance-type>
#
# With no args, this command shows the instance types available in all
# regions or zones.
#

set -eu -o pipefail

function main {
  exec 3>&1 1>&2

  declare -a all_regions all_az
  declare region_arg=${1:-}; shift || :
  declare az_arg=${1:-}; shift || :
  declare region az

  if [ -n "$region_arg" ]; then
    mapfile -t all_regions <<<"$(
      tr ',' '\n' <<<"$region_arg" | sed -e '/^\s*$/d' | sort -b | uniq
      )"
  else
    echo "Getting the list of regions"

    mapfile -t all_regions <<<"$(
      aws ec2 describe-regions --output text \
        --query 'Regions[*].[RegionName]' | sort
      )"
  fi

  if [ -n "$az_arg" ]; then
    declare -a az_names

    mapfile -t az_names <<<"$(
        tr ',' '\n' <<<"$az_arg" | sed -e '/^\s*$/d' | sort -b | uniq
      )"

    for region in "${all_regions[@]}"; do
      for az in "${az_names[@]}"; do
        all_az+=("${region}${az}")
      done
    done
  else
    for region in "${all_regions[@]}"; do
      echo "Getting the list of availability zones in region $region"

      mapfile -t all_az <<<"$(
        aws ec2 describe-availability-zones \
          --region "$region" --query 'AvailabilityZones[*].[ZoneName]' \
          --output text | sort)"
    done
  fi

  exec 1>&3 3>&-

  declare cnt=1
  declare num_az="${#all_az[@]}"

  {
    for az in "${all_az[@]}"; do
      echo "Checking availability zone $az ($cnt/$num_az)"$'\n' >&2

      region=$(awk -F- '{num=$3; sub(/[^0-9]+$/, "", num); printf "%s-%s-%d\n", $1, $2, num}' <<<"$az")

      (
        set -x
        aws ec2 describe-reserved-instances-offerings \
          --region "$region" \
          --filters "Name=availability-zone,Values=$az" \
          --product-description "Linux/UNIX (Amazon VPC)" \
          --offering-class "standard" \
          --instance-tenancy default
      ) | jq -r '.ReservedInstancesOfferings[] | .InstanceType' \
        | awk '{printf "%s,%s,%s\n", "'"${region}"'", "'"${az}"'", $0}'

      ((++cnt))
    done
  } | sort -b | uniq
}


main "$@"
