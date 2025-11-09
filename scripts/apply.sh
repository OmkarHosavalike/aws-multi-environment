#!/bin/bash
ws="$1"
cd "$(dirname "$0")/../terraform"

terraform init -input=false -no-color -backend-config="bucket=${bucket}" \
    -backend-config="key=${TF_WORKSPACE}/terraform.tfstate"
    
terraform workspace select "$ws" || terraform workspace new "$ws"

if [ -f "${ws}.tfvars" ]; then
    terraform apply -var-file="${ws}.tfvars" --auto-approve
else
    terraform apply --auto-approve
fi
