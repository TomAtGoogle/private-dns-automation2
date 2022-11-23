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


def dns_record_add(event, context):
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
  project = topic['resource']['labels']['project_id']
  managed_zone = 'gcp-private-zone'
  instance_automanaged = False

  credentials, project = google.auth.default(
      scopes=['https://www.googleapis.com/auth/ndev.clouddns.readwrite',
              'https://www.googleapis.com/auth/compute.readonly'])

  if 'labels' in topic['protoPayload']['request']:
    labels = topic['protoPayload']['request']['labels']
    for label in labels:
      if label['key'] == 'dns_automanage' and label['value'] == 'true':
        instance_automanaged = True
  if instance_automanaged:
    dns_change = discovery.build('dns', 'v1', credentials=credentials)

    # Get IP from instance
    compute = discovery.build('compute', 'v1', credentials=credentials)
    instance = compute.instances().get(
        project=project,
        zone=topic['resource']['labels']['zone'],
        instance=topic['protoPayload']['request']['name']).execute()

    # Build record
    change_body = {
        "additions": [
            {
              "kind": "dns#resourceRecordSet",
              "type": "A",
              "name": instance['hostname'] + '.',
              "ttl": 86400,
              "rrdatas": [
                  instance['networkInterfaces'][0]['networkIP']
              ],
            }
        ]
    }

    change_request = dns_change.changes().create(
        project=project,
        managedZone=managed_zone,
        body=change_body)
    change_response = change_request.execute()
