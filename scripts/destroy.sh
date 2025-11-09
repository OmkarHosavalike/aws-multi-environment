#!/bin/bash
ws="$1"
cd "$(dirname "$0")/../terraform"

terraform init -input=false
terraform workspace select "$ws"
terraform destroy -var-file="${ws}.tfvars" --auto-approve || terraform destroy --auto-approve