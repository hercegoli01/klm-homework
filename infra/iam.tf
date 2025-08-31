# Cloud Run Invoker – bárki elérheti az API-t
resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.notes_service.name
  location = var.region
  project  = var.project_id
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Secret Manager hozzáférés – Cloud Run SA olvashatja a DB password-öt
resource "google_secret_manager_secret_iam_member" "db_password_access" {
  secret_id = google_secret_manager_secret.db_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.notes_sa.email}"
}

# Cloud SQL Client – Cloud Run SA csatlakozhat az adatbázishoz
resource "google_project_iam_member" "cloud_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.notes_sa.email}"
}