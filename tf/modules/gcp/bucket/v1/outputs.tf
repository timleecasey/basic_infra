output "bucket_name" {
  description = "The name of the created bucket."
  value       = google_storage_bucket.this.name
}

output "bucket_self_link" {
  description = "The self_link of the bucket resource."
  value       = google_storage_bucket.this.self_link
}

output "bucket_url" {
  description = "HTTPS URL to access the bucket."
  value       = google_storage_bucket.this.url
}
