variable "project_id" {}

variable "gke_cluster_name" {
  default = "playground"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "primary_ip_cidr" {
  default = "192.168.0.0/24"
}

variable "cluster_ipv4_cidr_block" {
  default = "10.0.0.0/16"
}

variable "services_ipv4_cidr_block" {
  default = "10.1.0.0/20"
}

variable "master_ipv4_cidr_block" {
  default = "10.2.0.0/28"
}

variable "proxy_only_ip_cidr" {
  default = "192.168.254.0/23"
}

variable "psc_ip_cidr" {
  default = "192.168.253.0/26"
}

variable "iam_roles_list" {
  type = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
  ]
}

variable "iap_proxy_ip_cidr" {
  default = "192.168.100.0/29"
}
variable "create_iap_proxy_vm" {
  description = "bastion vm creation flag"
  default = false
}
