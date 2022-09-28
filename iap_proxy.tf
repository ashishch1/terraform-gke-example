resource "google_compute_subnetwork" "iap_subnet" {
  name                     = "${var.gke_cluster_name}-iap-subnet"
  ip_cidr_range            = var.iap_proxy_ip_cidr
  network                  = google_compute_network.k8s_vpc.id
  private_ip_google_access = "true"
  region                   = var.region
}

resource "google_compute_firewall" "iap_tcp_forwarding" {
  name    = "allow-ingress-from-iap"
  network = google_compute_network.k8s_vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "8888"] # 8888 = tinyproxy port
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap"]
}

resource "google_compute_instance" "iap-proxy" {
  count        = var.create_iap_proxy_vm ? 1 : 0
  name         = "gke-iap-proxy"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["iap"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.k8s_vpc.id
    subnetwork = google_compute_subnetwork.iap_subnet.name
  }

  metadata_startup_script = file("./scripts/startup.sh")

  depends_on = [
    google_compute_router_nat.k8s_vpc_router_nat
  ]
}
