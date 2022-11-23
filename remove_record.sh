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


# This script removes DNS records from the private zone.

ip="$(curl http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip -H "Metadata-Flavor: Google")"

gcloud dns record-sets transaction start --zone=gcp-private-zone

gcloud dns record-sets transaction remove "$ip" --name="$(hostname)" \
  --ttl="30" \
  --type="A" \
  --zone=gcp-private-zone

gcloud dns record-sets transaction execute --zone=gcp-private-zone
