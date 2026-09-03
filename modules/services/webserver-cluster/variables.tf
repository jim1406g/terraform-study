locals {
  http_port = 80
  all_ips   = ["0.0.0.0/0"]
}

variable "alb_external_address" {
  description = "Public address for ALB"
  type        = string
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "enable_instance_egress" {
  default     = false
  description = "Enable egress for web-cluster's instances"
  type        = bool
}

variable "labels" {
  description = "Custom labels to set on Instances"
  type        = map(string)
  default     = {}
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}

variable "db_remote_state_s3_profile" {
  description = "The name of the profile for S3 with database's remote state"
  type        = string
}

variable "fixed_scale" {
  default     = 1
  description = "Fixed scale for instance group"
  type        = number
}

variable "instance_template_platform_id" {
  default     = "standard-v1"
  description = "Platform for template of instances"
  type        = string
}

variable "instance_template_resources" {
  default = {
    core_fraction = 5
    cores         = 2
    memory        = 4
  }
  description = "Resources for template of instances"
  type        = map(number)
}

variable "network_name" {
  description = "Yandex cloud network Name"
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
