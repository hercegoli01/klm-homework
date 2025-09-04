resource "google_vpc_access_connector" "notes_connector" {
  count   = var.use_public_ip ? 0 : 1
  name    = "notes-connector"
  region  = var.region
  project = var.project_id

  subnet {
    name = google_compute_subnetwork.notes_connector_subnet[0].name
  }

  machine_type  = "e2-micro"
  min_instances = 2
  max_instances = 3
}
