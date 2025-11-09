#!/bin/bash

TF_DIR="../terraform"
AN_DIR="../ansible"

cd $TF_DIR
TF_OUTPUT=$(terraform output -json)

cd $AN_DIR
IPS=$(echo "$TF_OUTPUT" | jq -r '.ec2_public_ips.value[]')
ENV=$(echo "$TF_OUTPUT" | jq -r '.environment.value')
INVENTORY_FILE="$ENV-inventory.ini"

echo "[web]" > "$INVENTORY_FILE"
for ip in $IPS; do
    echo "$ip ansible_user=ec2-user ansible_ssh_private_key_file=../keys/$ENV-demo-key.pem" >> "$INVENTORY_FILE"
done

echo "" >> "$INVENTORY_FILE"
echo "[all:vars]" >> "$INVENTORY_FILE"
echo "environment=$ENV" >> "$INVENTORY_FILE"

export ANSIBLE_HOST_KEY_CHECKING=false

echo "Inventory generated: $INVENTORY_FILE"
