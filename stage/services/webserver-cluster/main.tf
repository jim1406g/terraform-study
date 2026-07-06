module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  alb_external_address = "158.160.173.249"
  service_account_id   = var.service_account.id
  zone_subnet          = var.zone_subnet
}
