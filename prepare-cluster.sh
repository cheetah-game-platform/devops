#!/bin/bash
set -e

# namespace для отдельных инсталляция платформы
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
HOST=$base_domain \
  GRAFANA_ADMIN_PASSWORD=$grafana_admin_password \
  CLUSTER_ISSUER_EMAIL=$cluster_issuer_email \
  PROMETHEUS_ADMIN_AUTH=$prometheus_admin_auth \
  helmwave up --build --kubedog

