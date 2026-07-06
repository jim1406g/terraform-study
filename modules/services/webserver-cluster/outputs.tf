output "alb_external_address" {
  description = "IPv4 endpoint for the webserver cluster"
  value       = yandex_alb_load_balancer.webcl.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}
