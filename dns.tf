/*
Copyright 2020 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#<!--* freshness: { owner: 'ttaggart@google.com' reviewed: '2022-nov-23' } *-->


# *************** [ DNS zones ] ****************
# **********************************************

resource "google_dns_managed_zone" "gcp_private_zone" {
  #provider    = google-beta #borg
  project     = google_project.private_dns.project_id
  name        = var.gcp_zone_name
  dns_name    = var.gcp_dns_zone
  description = "Private GCP DNS zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.private_dns.self_link
      #network_url = "https://www.googleapis.com/compute/v1/projects/private-dns-pid-2075248487/global/networks/network1" #borg
    }
  }

  depends_on = [
    # The project's services must be set up before the
    # instance is enabled or the DNS API calls will fail.
    google_project_service.dns_api,  
  ]
}
