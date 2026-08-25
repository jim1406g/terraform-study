provider "yandex" {
  zone                     = var.zone_subnet.zone0.zone
  cloud_id                 = "b1gv7nnhp4nje6bct6la"
  folder_id                = "b1g197129s2l7e4j8o6s"
  service_account_key_file = var.service_account.key_file
}
