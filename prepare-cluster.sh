#!/bin/bash
set -e


# namespace для отдельных инсталляция платформы
kubectl create ns system && true
kubectl create ns production && true
kubectl create ns stage1 && true
kubectl create ns stage2 && true
kubectl create ns stage3 && true
kubectl create ns stage4 && true
kubectl create ns stage5 && true

base_domain=$1
cluster_issuer_email=$2
prometheus_admin_password=$3
grafana_admin_password=$4

prometheus_admin_auth=$(echo $prometheus_admin_password | htpasswd -n -i admin | openssl enc -A -base64)
HOST=$base_domain GRAFANA_ADMIN_PASSWORD=$grafana_admin_password helmwave up --build --kubedog

# дополнительные настройки монторинга для платформы
helm upgrade --install -n system monitoring-config charts/monitoring-config \
  --set global.prometheusAdminAuth=$prometheus_admin_auth

# cluster issuer для LetsEncrypt
helm upgrade --install -n system issuer charts/issuer \
  --set global.clusterIssuerEmail=$cluster_issuer_email
