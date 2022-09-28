resource "google_container_cluster" "primary" {
  provider = google-beta

  name     = var.gke_cluster_name
  location = var.zone

  release_channel {
    channel = "RAPID"
  }

  network    = google_compute_network.k8s_vpc.id
  subnetwork = google_compute_subnetwork.k8s_subnet.id

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  datapath_provider = "ADVANCED_DATAPATH"
  network_policy {
    enabled = false
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.iap_proxy_ip_cidr
      display_name = "bastion"
    }
  }

  initial_node_count = 1
  node_config {
    service_account = google_service_account.gke_sa.email
    machine_type    = "e2-medium"
  }
  confidential_nodes {
    enabled = false
  }

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      maximum       = 4
    }
    resource_limits {
      resource_type = "memory"
      maximum       = 8
    }
    auto_provisioning_defaults {
      service_account = google_service_account.gke_sa.email
    }
  }

}
