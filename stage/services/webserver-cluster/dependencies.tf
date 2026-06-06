data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "terraform-up-and-running-state"
    region = "ru-central1"
    key    = "terraform-study/stage/data-stores/mysql/terraform.tfstate"

    profile = "jim1406-sa"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция при описании бэкенда для Terraform версии старше 1.6.1.
  }
}

data "yandex_vpc_network" "net" {
  name = "default"
}
