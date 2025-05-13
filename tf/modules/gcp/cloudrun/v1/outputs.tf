output "url" {
  description = "The HTTPS URL of the Cloud Run service"
  value       = google_cloud_run_service.this.status[0].url
}

output "service_name" {
  description = "The name of the Cloud Run service"
  value       = google_cloud_run_service.this.name
}
