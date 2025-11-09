#!/bin/bash

echo "Started deployment to $1 at `date`"
ws="$1"
chmod +x *.sh

./apply.sh "$ws"
chmod +x ../ansible/*.sh

../ansible/generate_inventory.sh

ansible-playbook ../ansible/site.yml -i ../ansible/$ws-inventory.ini

echo "Deployment to $1 Completed at `date`"
