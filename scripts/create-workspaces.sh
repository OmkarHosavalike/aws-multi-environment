#!/bin/bash
cd "$(dirname "$0")/../terraform"
terraform init -input=false -backend-config="bucket=${bucket}" \
     -backend-config="key=${TF_WORKSPACE}/terraform.tfstate"

for ws in dev prod; do
    if terraform workspace list | grep -qE "\\b${ws}\\b"; then
        terraform workspace select "$ws"
    else
        terraform workspace new "$ws"
    fi
done

echo "Workspaces available: "
terraform workspace list