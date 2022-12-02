#!/bin/bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#<!--* freshness: { owner: 'ttaggart@google.com' reviewed: '2022-nov-23' } *-->


# This script sets the env variables.

#### Below commands needs to be set from shell if #####
#### your account is part of a gcp organization.  #####
#### Update the your-organization-name.           #####
# TF_VAR_org_id=$(gcloud organizations list | \
#    awk '/your-organization-name/ {print $2}')
# export TF_VAR_org_id
#######################################################

TF_VAR_user_account="$(gcloud auth list \
  --filter=status:ACTIVE \
  --format="value(account)")"
export TF_VAR_user_account

TF_VAR_billing_account="$(gcloud beta billing accounts list \
  --format="value(ACCOUNT_ID)" \
  --filter=NAME:"$TF_VAR_billing_name")"
export TF_VAR_billing_account

TF_VAR_private_dns_pid="$(echo private-dns-pid-$(od -An -N4 -i /dev/random) \
  | sed 's/ //')"
export TF_VAR_private_dns_pid

TF_VAR_private_dns_pname=private_dns_network
export TF_VAR_private_dns_pname

TF_VAR_region=us-central1
export TF_VAR_region

TF_VAR_zone=us-central1-a
export TF_VAR_zone

TF_VAR_gcp_dns_zone=[YOUR-FQDN].
export TF_VAR_gcp_dns_zone

TF_VAR_hostname=vm2.[YOUR-FQDN]
export TF_VAR_hostname

TF_VAR_gcp_zone_name=gcp-private-zone
export TF_VAR_gcp_zone_name

TF_VAR_bucketname="$(echo images-$(od -An -N4 -i /dev/random) \
  | sed 's/ //')"
export TF_VAR_bucketname
