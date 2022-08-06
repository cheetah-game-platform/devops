#!/bin/bash
#
# Подготовка кластера, установка необходимых сервисов (кроме собственно игры)
#

# set default storage class
# kubectl patch storageclass fast.ru-2c  -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# install linkerd
helm repo add linkerd https://helm.linkerd.io/stable
step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure
step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key
kubectl create ns linkerd

# Добавить необходимые параметры
./update-monitoring.sh

helm install linkerd2 \
  --set-file identityTrustAnchorsPEM=ca.crt \
  --set-file identity.issuer.tls.crtPEM=issuer.crt \
  --set-file identity.issuer.tls.keyPEM=issuer.key \
  linkerd/linkerd2

helm upgrade --install linkerd-viz linkerd/linkerd-viz \
  --set prometheus.enabled=false \
  --set grafana.enabled=false \
  --set prometheusUrl=http://monitoring-kube-prometheus-prometheus.monitoring:9090 \
  --set grafanaUrl=http://monitoring-grafana.monitoring:80
