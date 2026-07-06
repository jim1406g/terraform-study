variable "alb_external_address" {
  description = "Public address for ALB"
  type        = string
}

variable "server_port" {
  default     = 8080
  description = "Port for HTTP requests"
  type        = number
}

variable "service_account_id" {
  description = "Yandex IAM Service Account ID"
  type        = string
}

variable "zone_subnet" {
  #   default = {
  #     zone0 = {
  #       zone      = "ru-central1-b"
  #       subnet    = "default-ru-central1-b"
  #       subnet_id = "e2l5i4p8utd89i0ad456"
  #     }
  #     zone1 = {
  #       zone      = "ru-central1-a"
  #       subnet    = "default-ru-central1-a"
  #       subnet_id = "e9btg82r2u94c1432bbn"
  #     }
  #   }
  description = "Zones and Subnets"
  type        = map(map(string))
}
