#!/bin/bash

env=$1
echo "Applying Terraform for environment: $env"
if [ -z "$env" ]; then
  echo "Please provide the environment name as an argument. Usage: $0 <environment-name>, environment-name: dev, test, prod"
  exit 1
fi

service=$2
echo "Destroying Terraform for service: $service"
if [ -z "$service" ]; then
  echo "Please provide the service name as an argument. Usage: $0 <service-name>, service-name: azdo-team, cp4i"
  exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BASE_DIR=$(dirname "$SCRIPT_DIR")
echo "Base directory: $BASE_DIR"

cd "$BASE_DIR/terraform/azure/services/$service"

tfvars_file="$BASE_DIR/terraform/azure/services/$service/envs/${env}.tfvars"

terraform destroy -var-file="$tfvars_file" -auto-approve
