resource "google_compute_network" "notes_vpc" {
  name                    = "notes-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "notes_connector_subnet" {
  count                   = var.use_public_ip ? 0 : 1
  name                    = "notes-connector-subnet"
  ip_cidr_range           = "10.100.0.0/28"
  region                  = var.region
  network                 = google_compute_network.notes_vpc.id
  project                 = var.project_id
  private_ip_google_access = true
}

resource "google_compute_subnetwork_iam_member" "vpcaccess_sa_networkuser" {
  count      = var.use_public_ip ? 0 : 1
  subnetwork = google_compute_subnetwork.notes_connector_subnet[0].name
  region     = var.region
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-vpcaccess.iam.gserviceaccount.com"
}
