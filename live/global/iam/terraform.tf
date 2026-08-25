terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "terraform-up-and-running-state"
    region = "ru-central1"
    key    = "terraform-study/live/global/iam/terraform.tfstate"
    # Статический ключ доступа для сервисного аккаунта (AWS-совместимый)
    # mkdir -p ~/.aws
    # cat > ~/.aws/credentials << EOF
    # [jim1406-sa]
    # aws_access_key_id = YCA...
    # aws_secret_access_key = YCT...
    # EOF
    profile = "jim1406-sa"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }
}
