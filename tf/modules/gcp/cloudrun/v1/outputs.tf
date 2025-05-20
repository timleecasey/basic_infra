output "url" {
  description = "The HTTPS URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.this.uri
}

output "service_name" {
  description = "The name of the Cloud Run service"
  value       = google_cloud_run_v2_service.this.name
}

output "sa_email" {
  description = "The email of the SA for the service"
  value       = google_service_account.sa.email
}

output "repo_id" {
  description = "Repository id"
  value = google_artifact_registry_repository.this.repository_id
}
