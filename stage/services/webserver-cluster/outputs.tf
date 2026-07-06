output "alb_external_address" {
  description = "IPv4 endpoint for the webserver cluster"
  value       = module.webserver_cluster.alb_external_address
}

output "alb_external_ports" {
  description = "Endpoint ports for the webserver cluster"
  value       = module.webserver_cluster.alb_external_ports
}