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


variable "user_account" {
   type = string
   description = "GCP user account used to complete solution."
}

variable "billing_account" {
   type = string
   description = "GCP billing account number." 
}

variable "org_id" {
   type = string
   description = "GCP organization number."
}

variable "private_dns_pid" {
   type = string
   description = "GCP project of the host project."
}

variable "private_dns_pname" {
   type = string
   description = "Name of the VPC network in the project."
}

variable "region" {
   type = string
   description = "GCP region where resources are created."
}

variable "zone" {
   type = string
   description = "GCP zone in the var.region where resources are created."
}

variable "gcp_dns_zone" {
   type = string
   description = "DNS FQDN for the GCP private zone."
}

variable "gcp_zone_name" {
   type = string
   description = "GCP private DNS zone name."
}

variable "bucketname" {
   type        = string
   description = "Bucket name."
}

variable "hostname" {
   type        = string
   description = "VM hostname."
}

