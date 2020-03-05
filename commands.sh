#!/usr/bin/env bash

open https://console.cloud.google.com/home/activity?project=bedenktijdje-temp

git submodule update --init zone-printer

docker build zone-printer -t hermanbanken/zone-printer:demo

docker push hermanbanken/zone-printer:demo

terraform init

terraform plan -var 'gcp_project=bedenktijdje-temp'

terraform apply -var 'gcp_project=bedenktijdje-temp' -auto-approve
