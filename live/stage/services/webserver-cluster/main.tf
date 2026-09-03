module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  alb_external_address       = "158.160.173.249"
  cluster_name               = "example-web-cluster"
  db_remote_state_bucket     = "terraform-up-and-running-state"
  db_remote_state_key        = "terraform-study/live/stage/data-stores/mysql/terraform.tfstate"
  db_remote_state_s3_profile = var.service_account.s3_profile
  # enable_instance_egress     = true
  fixed_scale                = 2
  network_name               = var.network_name
  service_account_id         = var.service_account.id
  zone_subnet                = var.zone_subnet

  labels = {
    owner      = "jim1406"
    managed_by = "terraform"
  }
}
