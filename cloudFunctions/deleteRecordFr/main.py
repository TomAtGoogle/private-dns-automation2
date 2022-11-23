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

#<!--* freshness: { owner: 'ttaggart@google.com' reviewed: '2023-nov-23' } *-->


def dns_record_delete(event, context):
  """Cloud Function to automate DNS record adds. Lint as: python3.

  Args:
       event (dict): The pub/sub event dictionary.
       context (google.cloud.functions.Context): The Cloud Functions event
       metadata.
  """

  import base64
  import json

  import google.auth
  from googleapiclient import discovery

  
  topic = base64.b64decode(event['data']).decode('utf-8')
  topic = json.loads(topic)
  managed_zone = 'gcp-private-zone'
  fqdn_suffix = '.naga-gcp.com.'

  credentials, project = google.auth.default(
      scopes=['https://www.googleapis.com/auth/ndev.clouddns.readwrite',])
  project = topic['resource']['labels']['project_id']

  # Get IP address from DNS record
  get_a_record = discovery.build('dns', 'v1', credentials=credentials)
  start_of_name = topic['protoPayload']['resourceName'].rfind('/') + 1
  fqdn = topic['protoPayload']['resourceName'][start_of_name:] + fqdn_suffix
  query_request = get_a_record.resourceRecordSets().list(
      project=project,
      managedZone=managed_zone,
      name=fqdn)
  query_response = query_request.execute()

  # Build record
  change_body = {
        "deletions": [
            {
              "kind": "dns#resourceRecordSet",
              "type": "A",
              "name": fqdn,
              "ttl": query_response['rrsets'][0]['ttl'],
              "rrdatas": query_response['rrsets'][0]['rrdatas'],
            }
        ]
  }

  dns_change = discovery.build('dns', 'v1', credentials=credentials)
  change_request = dns_change.changes().create(
      project=project,
      managedZone=managed_zone,
      body=change_body)
  change_response = change_request.execute()
