resource "yandex_vpc_security_group" "instance" {
  name       = "${var.cluster_name}-instance-security-group"
  network_id = data.yandex_vpc_network.net.id

  ingress {
    protocol       = "TCP"
    description    = "WEB"
    v4_cidr_blocks = local.all_ips
    port           = var.server_port
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = local.all_ips
  }
}

resource "yandex_vpc_security_group" "alb" {
  name       = "${var.cluster_name}-alb-security-group"
  network_id = data.yandex_vpc_network.net.id

  ingress {
    protocol       = "TCP"
    description    = "WEB"
    v4_cidr_blocks = local.all_ips
    port           = local.http_port
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = local.all_ips
  }
}

resource "yandex_compute_instance_group" "webcl" {
  name               = "${var.cluster_name}-instance-group"
  service_account_id = var.service_account_id

  allocation_policy {
    zones = [var.zone_subnet.zone0.zone, var.zone_subnet.zone1.zone]
  }

  application_load_balancer {
    target_group_name        = "${var.cluster_name}-instance-target-group"
    target_group_description = "${var.cluster_name} target group by instance group"
  }

  deploy_policy {
    max_creating     = 2
    max_deleting     = 2
    max_expansion    = 2
    max_unavailable  = 1
    startup_duration = 120
  }

  instance_template {
    name        = "${var.cluster_name}-{instance.index}"
    platform_id = var.instance_template_platform_id

    boot_disk {
      initialize_params {
        # ubuntu-24-04-lts-v20260413 (yc compute image list --folder-id standard-images)
        image_id = "fd83esfomhq25p2ono90"
      }
    }

    metadata = {
      user-data = templatefile("${path.module}/user-data.yaml", {
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
      core_fraction = var.instance_template_resources.core_fraction
      cores         = var.instance_template_resources.cores
      memory        = var.instance_template_resources.memory
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

resource "yandex_alb_backend_group" "webcl" {
  name = "${var.cluster_name}-backend-group"

  http_backend {
    name             = "http-backend"
    port             = var.server_port
    target_group_ids = [yandex_compute_instance_group.webcl.application_load_balancer[0].target_group_id]

    healthcheck {
      interval = "5s"
      timeout  = "3s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "webcl" {
  name = "${var.cluster_name}-http-router"
}

resource "yandex_alb_virtual_host" "webcl" {
  http_router_id = yandex_alb_http_router.webcl.id
  name           = "${var.cluster_name}-alb-vhost"

  route {
    name = "default-route"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.webcl.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "webcl" {
  name               = "${var.cluster_name}-alb"
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
          address = var.alb_external_address
        }
      }
      ports = [local.http_port]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.webcl.id
      }
    }
  }
}
