# terraform-study

Занятия по книге _Евгения Брикмана_ **Terrafotm**.

При этом используется инфраструктура _Yandex.Cloud_.

## Ссылки

  - [Style Guide](https://developer.hashicorp.com/terraform/language/style)

## Yandex.Cloud

### Документация

  - [Интерфейс командной строки](https://yandex.cloud/ru/docs/cli/)
  - [Создание профиля](https://yandex.cloud/ru/docs/cli/operations/profile/profile-create)
  - [Создание пустого профиля и добавление параметров вручную](https://yandex.cloud/ru/docs/cli/operations/profile/profile-create#create)
  - [Аутентифицируйтесь от имени сервисного аккаунта с помощью авторизованного ключа](https://yandex.cloud/ru/docs/cli/operations/authentication/service-account#auth-as-sa)
  - [Yandex Compute Cloud](https://yandex.cloud/ru/docs/compute/)
  - [Terraform в Yandex Cloud](https://yandex.cloud/ru/docs/terraform/)
  - [Начало работы с Terraform](https://yandex.cloud/ru/docs/terraform/quickstart)
  - [Yandex Cloud Provider](https://yandex.cloud/ru/docs/terraform/tf-ref/overview)

### Предварительные настройки

`cat ~/.terraformrc`

```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

## Общая последовательность действий

`terraform init`

`terraform validate`

`terraform fmt`

`terraform plan`

`terraform apply`
