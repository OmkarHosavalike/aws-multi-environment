#!/bin/bash
ws="$1"
cd "$(dirname "$0")/../terraform"
  
#terraform init -input=false -no-color -backend-config="bucket=${bucket}" \
   # -backend-config="key=terraform.tfstate"
    #-backend-config="key=${ws}/terraform.tfstate"

terraform workspace select "$ws" || { echo "Workspace $ws not available" ; exit 1; }

if [ -f "${ws}.tfvars" ]; then
    terraform apply -var-file="${ws}.tfvars" --auto-approve
else
    echo "environment specific tfvars file doesn't exist"
    exit 1;
fi
