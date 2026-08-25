output "all_sa_ids" {
  value       = yandex_iam_service_account.example[*].id
  description = "The IDs of all SA"
}
