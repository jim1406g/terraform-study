provider "yandex" {
  zone                     = var.zone_subnet.zone0.zone
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  service_account_key_file = var.service_account.key_file
}
