resource "yandex_iam_service_account" "example" {
  for_each = toset(var.example_user_names)
  name     = each.value
}

resource "yandex_iam_service_account" "existing_user" {
  description = "Для теста terraform import"
  name = "yevgeniy-brikman"
}
