# Cloud Run Service Account
resource "google_service_account" "notes_sa" {
  account_id   = "notes-api-sa"
  display_name = "Notes API Service Account"
}

# Cloud Run SA -> Cloud SQL client
resource "google_project_iam_member" "notes_sa_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.notes_sa.email}"
}

# Cloud Run SA -> Secret Manager accessor
resource "google_project_iam_member" "notes_sa_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.notes_sa.email}"
}

resource "google_cloud_run_service_iam_member" "notes_invoker" {
  count    = var.enable_cloudrun ? 1 : 0
  project  = var.project_id
  location = var.region
  service  = try(google_cloud_run_service.notes_service[0].name, "")
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.notes_sa.email}"
}

