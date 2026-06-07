resource "yandex_vpc_security_group" "instance" {
  name       = "terraform-example-instance-security-group"
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

resource "yandex_vpc_security_group" "alb" {
  name       = "terraform-example-alb-security-group"
  network_id = data.yandex_vpc_network.net.id

  ingress {
    protocol       = "TCP"
    description    = "WEB"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance_group" "example" {
  name               = "terraform-example-instance-group"
  service_account_id = var.service_account.id

  allocation_policy {
    zones = [var.zone_subnet.zone0.zone, var.zone_subnet.zone1.zone]
  }

  application_load_balancer {
    target_group_name        = "terraform-example-instance-target-group"
    target_group_description = "terraform-example target group by instance group"
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
      user-data = templatefile("user-data.yaml", {
        db_address  = data.terraform_remote_state.db.outputs.address
        db_port     = "3306"
        server_port = var.server_port
      })
    }

    network_interface {
      nat                = false
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

resource "yandex_alb_backend_group" "example" {
  name = "terraform-example-backend-group"

  http_backend {
    name             = "http-backend"
    port             = var.server_port
    target_group_ids = [yandex_compute_instance_group.example.application_load_balancer[0].target_group_id]

    healthcheck {
      interval = "5s"
      timeout  = "3s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "example" {
  name = "terraform-example-http-router"
}

resource "yandex_alb_virtual_host" "example" {
  http_router_id = yandex_alb_http_router.example.id
  name           = "terraform-example-alb-vhost"

  route {
    name = "default-route"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.example.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "example" {
  name               = "terraform-example-alb"
  network_id         = data.yandex_vpc_network.net.id
  security_group_ids = [yandex_vpc_security_group.alb.id]

  allocation_policy {
    location {
      subnet_id = var.zone_subnet.zone0.subnet_id
      zone_id   = var.zone_subnet.zone0.zone
    }
    location {
      subnet_id = var.zone_subnet.zone1.subnet_id
      zone_id   = var.zone_subnet.zone1.zone
    }
  }

  listener {
    name = "http"

    endpoint {
      address {
        external_ipv4_address {
          address = "158.160.173.249"
        }
      }
      ports = ["80"]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.example.id
      }
    }
  }
}
