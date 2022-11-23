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


provider "google" {
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  region  = var.region
  zone    = var.zone
}

data "google_billing_account" "acct" {
  billing_account = var.billing_account
  open            = true
}

resource "google_project" "private_dns" {
  name            = "private-dns"
  project_id      = var.private_dns_pid
  org_id          = var.org_id
  billing_account = data.google_billing_account.acct.id
}

resource "google_project_service" "compute_api" {
  project   = google_project.private_dns.project_id
  service   = "compute.googleapis.com"
}

resource "google_project_service" "service_usage_api" {
  project   = google_project.private_dns.project_id
  service   = "serviceusage.googleapis.com"
}

resource "google_project_service" "dns_api" {
  project   = google_project.private_dns.project_id
  service   = "dns.googleapis.com"
}

resource "google_project_service" "logging_api" {
  project   = google_project.private_dns.project_id
  service   = "logging.googleapis.com"

  disable_dependent_services=true
}

resource "google_project_service" "cloudfunctions_api" {
  project   = google_project.private_dns.project_id
  service   = "cloudfunctions.googleapis.com"

  disable_dependent_services=true
}

resource "google_project_service" "monitoring_api" {
  project   = google_project.private_dns.project_id
  service   = "monitoring.googleapis.com"

  disable_dependent_services=true
}

resource "google_project_service" "cloudbuild_api" {
  project   = google_project.private_dns.project_id
  service   = "cloudbuild.googleapis.com"

  disable_dependent_services=true
}

locals {
  add_record     = "${file("${path.module}/add_record.sh")}"
  remove_record  = "${file("${path.module}/remove_record.sh")}"
}
