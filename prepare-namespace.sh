#!/bin/bash
set -e

namespace=$1
openssl ecparam -name prime256v1 -genkey -out private.pem
openssl pkcs8  -topk8 -nocrypt -in private.pem -out private-pkcs8.pem
openssl ec -in private.pem -pubout -out public.pem
kubectl create secret generic jwt \
--namespace $namespace \
--from-file=public=public.pem \
--from-file=private=private-pkcs8.pem

rm private.pem
rm private-pkcs8.pem
rm public.pem

