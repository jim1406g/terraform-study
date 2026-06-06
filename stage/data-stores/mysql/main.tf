resource "yandex_mdb_mysql_cluster" "example" {
  name        = "terraform-example-mysql-cluster"
  environment = "PRESTABLE"
  network_id  = data.yandex_vpc_network.net.id
  version     = "8.0"

  host {
    zone      = var.zone_subnet.zone0.zone
    subnet_id = var.zone_subnet.zone0.subnet_id
  }

  mysql_config = {
    sql_mode                      = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
    max_connections               = 100
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
    innodb_print_all_deadlocks    = true
  }

  resources {
    resource_preset_id = "s1.micro"
    disk_type_id       = "network-hdd"
    disk_size          = 10
  }
}

# resource "yandex_mdb_mysql_user" "admin" {
#   cluster_id = yandex_mdb_mysql_cluster.example.id
#   name       = var.db_username
#   password   = var.db_password
#
#   permission {
#     database_name = ""
#     roles         = ["ALL"]
#   }
# }
