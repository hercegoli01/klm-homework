output "cloud_run_url" {
  value = try(google_cloud_run_service.notes_service[0].status[0].url, "")
}
