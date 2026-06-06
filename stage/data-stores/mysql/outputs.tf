output "address" {
  description = "Endpoint for the mysql database"
  value       = yandex_mdb_mysql_cluster.example.host[0].fqdn
}