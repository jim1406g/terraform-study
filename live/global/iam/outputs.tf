output "all_sa" {
  value       = yandex_iam_service_account.example
  description = "The IDs of all SA"
}

output "all_sa_ids" {
  value       = values(yandex_iam_service_account.example)[*].id
  description = "The IDs of all SA"
}
