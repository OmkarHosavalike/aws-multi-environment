#!/bin/bash
cd "$(dirname "$0")/../terraform"
#initialize dev by default
terraform init -input=false -backend-config="bucket=${bucket}" -backend-config="key=terraform.tfstate" 
#-backend-config="key=dev/terraform.tfstate"

for ws in dev prod; do
    if terraform workspace list | grep -qE "\\b${ws}\\b"; then
        terraform workspace select "$ws"
    else
        terraform workspace new "$ws"
    fi
done

echo "Workspaces available: "
terraform workspace list