#!/bin/bash
cd "$(dirname "$0")/../terraform"
terraform init -input=false

for ws in dev prod; do
    if terraform workspace list | grep -qE "\\b${ws}\\b"; then
        terraform workspace select "$ws"
    else
        terraform workspace new "$ws"
    fi
done

echo "Workspaces available: "
terraform workspace list