terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone                     = "ru-central1-b"
  cloud_id                 = "b1gv7nnhp4nje6bct6la"
  folder_id                = "b1g197129s2l7e4j8o6s"
  service_account_key_file = "/home/jim1406/.config/yandex-cloud/jim1406-sa-key.json"
}

resource "yandex_compute_instance" "example" {
  name        = "terraform-example"
  platform_id = "standard-v1"

  boot_disk {
    initialize_params {
      # ubuntu-24-04-lts-v20260413 (yc compute image list --folder-id standard-images)
      image_id = "fd83esfomhq25p2ono90"
    }
  }

  network_interface {
    subnet_id = "e2l5i4p8utd89i0ad456"
  }

  resources {
    core_fraction = 5
    cores         = 2
    memory        = 4
  }

  scheduling_policy {
    preemptible = true
  }
}