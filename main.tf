terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "service_account" {
  default = {
    id       = "ajenc66cncovv74n6act"
    key_file = "/home/jim1406/.config/yandex-cloud/jim1406-sa-key.json"
  }
  description = "yandex_iam_service_account"
  type        = map(string)
}

provider "yandex" {
  zone                     = "ru-central1-b"
  cloud_id                 = "b1gv7nnhp4nje6bct6la"
  folder_id                = "b1g197129s2l7e4j8o6s"
  service_account_key_file = var.service_account.key_file
}

variable "server_port" {
  default     = 8080
  description = "Port for HTTP requests"
  type        = number
}

data "yandex_vpc_network" "net" {
  name = "default"
}

resource "yandex_vpc_security_group" "instance" {
  name       = "terraform-example-instance"
  network_id = data.yandex_vpc_network.net.id

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


resource "yandex_compute_instance_group" "example" {
  name               = "terraform-example-ig"
  service_account_id = var.service_account.id

  allocation_policy {
    zones = ["ru-central1-a", "ru-central1-b"]
  }

  deploy_policy {
    max_creating     = 2
    max_deleting     = 2
    max_expansion    = 2
    max_unavailable  = 1
    startup_duration = 120
  }

  instance_template {
    name        = "terraform-example-{instance.index}"
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
      network_id         = data.yandex_vpc_network.net.id
      security_group_ids = [yandex_vpc_security_group.instance.id]
      subnet_ids         = data.yandex_vpc_network.net.subnet_ids
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

  scale_policy {
    fixed_scale {
      size = 2
    }
  }
}

output "public_ip" {
  description = "The public IP addresses of the web servers"
  value       = yandex_compute_instance_group.example.instances.*.network_interface.0.nat_ip_address
}