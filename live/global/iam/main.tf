resource "yandex_iam_service_account" "example" {
  count = length(var.example_user_names)
  name  = var.example_user_names[count.index]
}