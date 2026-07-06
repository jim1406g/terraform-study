output "alb_external_address" {
  description = "IPv4 endpoint for the webserver cluster"
  value       = yandex_alb_load_balancer.webcl.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "alb_external_ports" {
  description = "Endpoint ports for the webserver cluster"
  value       = yandex_alb_load_balancer.webcl.listener[0].endpoint[0].ports
}

output "alb_security_group_id" {
  description = "The ID of the Security Group attached to the Application Load Balancer"
  value       = yandex_vpc_security_group.alb.id
}

output "instance_security_group_id" {
  description = "The ID of the Security Group attached to the Instance Group"
  value       = yandex_vpc_security_group.instance.id
}
