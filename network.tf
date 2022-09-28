resource "google_compute_network" "k8s_vpc" {
  name = "${var.gke_cluster_name}-k8s-vpc"

  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "k8s_subnet" {
  name                     = "${var.gke_cluster_name}-subnet"
  ip_cidr_range            = var.primary_ip_cidr
  network                  = google_compute_network.k8s_vpc.id
  private_ip_google_access = "true"
  region                   = var.region
}

resource "google_compute_subnetwork" "proxy_only_subnet" {
  provider = google-beta

  name          = "${var.gke_cluster_name}-proxy-only-subnet"
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  ip_cidr_range = var.proxy_only_ip_cidr
  network       = google_compute_network.k8s_vpc.id
  region        = var.region
}

resource "google_compute_subnetwork" "psc_subnet" {
  provider = google-beta

  name                     = "${var.gke_cluster_name}-psc-subnet"
  purpose                  = "PRIVATE_SERVICE_CONNECT"
  ip_cidr_range            = var.psc_ip_cidr
  network                  = google_compute_network.k8s_vpc.id
  private_ip_google_access = "true"
  region                   = var.region
}

resource "google_compute_firewall" "lb_health_check" {
  name        = "allow-health-check"
  network     = google_compute_network.k8s_vpc.name
  description = "Allow health checks from GCP LBs"

  direction = "INGRESS"

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

resource "google_compute_router" "k8s_vpc_router" {
  name    = "${var.gke_cluster_name}-vpc-router"
  region  = var.region
  network = google_compute_network.k8s_vpc.id
}

resource "google_compute_router_nat" "k8s_vpc_router_nat" {
  name                               = "${var.gke_cluster_name}-vpc-router-nat"
  router                             = google_compute_router.k8s_vpc_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}
