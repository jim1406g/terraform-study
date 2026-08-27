# variable "network_name" {
#   default     = "default"
#   description = "Yandex cloud network Name"
#   type        = string
# }

variable "service_account" {
  default = {
    id         = "ajenc66cncovv74n6act"
    key_file   = "/home/jim1406/.config/yandex-cloud/jim1406-sa-key.json"
    s3_profile = "jim1406-sa"
  }
  description = "Yandex IAM Service Account"
  type        = map(string)
}

variable "example_user_names" {
  default     = ["neo", "trinity", "morpheus"]
  description = "Example Yandex IAM Service Accounts"
  type        = list(string)
}

variable "example_hero_thousand_faces" {
  default = {
    neo      = "hero"
    trinity  = "love interest"
    morpheus = "metor"
  }
  description = "Example map kind of users"
  type        = map(string)
}

variable "yc_cloud_id" {
  default     = "b1gv7nnhp4nje6bct6la"
  description = "Yandex cloud ID"
  type        = string
}

variable "yc_folder_id" {
  default     = "b1g197129s2l7e4j8o6s"
  description = "Yandex Cloud folder ID"
  type        = string
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