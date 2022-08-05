# DevOps поддержка платформы

## Настройка kubernetes кластера для развертывания платформы

### Подготовка

Необходимо установить openssl, helmwave, htpasswd

### Установка

```bash
./prepare-cluster.sh DOMAIN EMAIL PROMETHEUS_PASSWORD GRAFANA_PASSWORD
```

- DOMAIN - имя домена, все сервисы будут доступны по адресу SERVICE.DOMAIN, IP адрес домена должен совпадать с адресом
  nginx контроллера
- EMAIL - адрес электронной почты (любой, используется для LetsEncrypt)
- PROMETHEUS_PASSWORD - новый пароль для prometheus
- GRAFANA_PASSWORD - новый пароль для grafana

### FAQ

#### Не создаются диски для кластера в selectel.ru

У них не установлен класс дисков по-умолчанию. Для установки - выполните команду:

```
# получение имени класса
kubectl -n system  get storageclass
# установка его по умолчанию
kubectl patch storageclass !!REPLACE_CLASS_NAME!!  -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```


