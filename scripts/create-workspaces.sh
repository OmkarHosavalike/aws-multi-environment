#!/bin/bash
cd "$(dirname "$0")/../terraform"

for ws in dev prod; do
    terraform init -input=false -backend-config="bucket=${bucket}" -backend-config="key=${ws}/terraform.tfstate"
    if terraform workspace list | grep -qE "\\b${ws}\\b"; then
        terraform workspace select "$ws"
    else
        terraform workspace new "$ws"
    fi
done

echo "Workspaces available: "
terraform workspace list