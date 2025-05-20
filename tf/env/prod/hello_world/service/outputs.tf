output "external_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = module.proxy.url
}