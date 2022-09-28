resource "google_service_account" "gke_sa" {
  account_id   = "${var.gke_cluster_name}-gke-sa"
  display_name = "Custom GKE service account"
}

resource "google_project_iam_member" "gke_sa_iam_member" {
  project = var.project_id
  count   = length(var.iam_roles_list)
  role    = var.iam_roles_list[count.index]
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}
