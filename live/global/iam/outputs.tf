output "all_sa" {
  value       = yandex_iam_service_account.example
  description = "The IDs of all SA"
}

output "all_sa_ids" {
  value       = values(yandex_iam_service_account.example)[*].id
  description = "The IDs of all SA"
}

output "upper_names" {
  value = [for name in var.example_user_names : upper(name)]
}

output "short_upper_names" {
  value = [for name in var.example_user_names : upper(name) if length(name) < 5]
}

output "bios" {
  value = [for name, role in var.example_hero_thousand_faces : "${name} is the ${role}"]
}

output "upper_names_2" {
  value = { for name in var.example_user_names : upper(name) => name }
}

output "upper_roles" {
  value = { for name, role in var.example_hero_thousand_faces : upper(name) => upper(role) }
}

output "for_directive" {
  value = "%{for name in var.example_user_names}${name}, %{endfor}"
}

output "for_directive_index" {
  value = "%{for i, name in var.example_user_names}${i}) ${name}, %{endfor}"
}
