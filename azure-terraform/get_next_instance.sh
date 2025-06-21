#!/bin/bash

# ===========================
# CONFIGURE THESE VARIABLES
# ===========================
RESOURCE_GROUP="corp-rg"      # <-- Update to your resource group
PREFIX="corp"
RESOURCE_TYPE="vm"
APP="inventory"
ENV="prod"
REGION="eastus"

BASENAME="${PREFIX}-${RESOURCE_TYPE}-${APP}-${ENV}-${REGION}"

# ===========================
# GET EXISTING VM NAMES
# ===========================
VM_NAMES=$(az vm list \
  --resource-group "$RESOURCE_GROUP" \
  --query "[].name" \
  -o tsv)

# ===========================
# FIND NEXT INSTANCE NUMBER
# ===========================
MAX=0
for NAME in $VM_NAMES; do
  if [[ $NAME == ${BASENAME}-* ]]; then
    NUMBER="${NAME##*-}"
    if [[ $NUMBER =~ ^[0-9]+$ ]]; then
      if ((10#$NUMBER > MAX)); then
        MAX=$((10#$NUMBER))
      fi
    fi
  fi
done

NEXT=$((MAX + 1))
printf '{"next_instance": "%03d"}\n' "$NEXT"
