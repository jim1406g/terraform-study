# variable "db_username" {
#   description = "The username for the database"
#   type        = string
#   sensitive   = true
# }
#
# variable "db_password" {
#   description = "The password for the database"
#   type        = string
#   sensitive   = true
# }

variable "service_account" {
  default = {
    id       = "ajenc66cncovv74n6act"
    key_file = "/home/jim1406/.config/yandex-cloud/jim1406-sa-key.json"
  }
  description = "yandex_iam_service_account"
  type        = map(string)
}

variable "zone_subnet" {
  default = {
    zone0 = {
      zone      = "ru-central1-b"
      subnet    = "default-ru-central1-b"
      subnet_id = "e2l5i4p8utd89i0ad456"
    }
    zone1 = {
      zone      = "ru-central1-a"
      subnet    = "default-ru-central1-a"
      subnet_id = "e9btg82r2u94c1432bbn"
    }
  }
  description = "Zones and Subnets"
  type        = map(map(string))
}
