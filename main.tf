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

variable "server_port" {
  description = "Port for HTTP requests"
  type        = number
  default     = 8080
}

resource "yandex_vpc_security_group" "instance" {
  name = "terraform-example-instance"
  # default
  network_id = "enpuge6idiit2v65es7o"

  ingress {
    protocol       = "TCP"
    description    = "WEB"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = var.server_port
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
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

  metadata = {
    user-data = <<-EOF
      #cloud-config
      packages:
        - busybox
      write_files:
        - path: /opt/init_script.sh
          content: |
            #!/bin/bash
            echo "Hello World!"
            cat /opt/init_script.sh
            echo "Hello, World!" > index.html
            nohup busybox httpd -f -p $${1:-8080} &
          permissions: '0755'
      bootcmd:
        - /opt/init_script.sh ${var.server_port}
      runcmd:
        - /opt/init_script.sh ${var.server_port}
    EOF
  }

  network_interface {
    nat                = true
    security_group_ids = [yandex_vpc_security_group.instance.id]
    # default-ru-central1-b
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

output "public_ip" {
  description = "The public IP address of the web server"
  value       = yandex_compute_instance.example.network_interface[0].nat_ip_address
}