#!/bin/bash

TF_DIR="terraform/"
AN_DIR="../ansible/"

cd $TF_DIR
TF_OUTPUT=$(terraform output -json)
echo "output- $TF_OUTPUT"

IPS=$(echo "$TF_OUTPUT" | jq -r '.ec2_public_ips.value[]')
ENV=$(echo "$TF_OUTPUT" | jq -r '.environment.value')

PRIVATE_KEY=$(echo "$TF_OUTPUT" | jq -r '.key_pair_private_key.value' | sed '/^$/d')
KEY_FILE="$ENV-demo-key.pem"
echo "$PRIVATE_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

INVENTORY_FILE="$ENV-inventory.ini"

echo "[web]" > "$INVENTORY_FILE"
for ip in $IPS; do
    echo "$ip ansible_user=ec2-user ansible_ssh_private_key_file=$KEY_FILE" >> "$INVENTORY_FILE"
done

echo "" >> "$INVENTORY_FILE"
echo "[all:vars]" >> "$INVENTORY_FILE"
echo "environment=$ENV" >> "$INVENTORY_FILE"

echo "Inventory generated: $INVENTORY_FILE"
