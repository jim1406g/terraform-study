data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = var.db_remote_state_bucket
    region = "ru-central1"
    key    = var.db_remote_state_key

    profile = var.db_remote_state_s3_profile

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция при описании бэкенда для Terraform версии старше 1.6.1.
  }
}

data "yandex_vpc_network" "net" {
  name = var.network_name
}
