#!/bin/bash
# 
# 
# 
STORAGE_ACCOUNT_NAME=$1
RESOURCE_GROUP_NAME=$2
CONTAINER_NAME=tfstate


# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_RAGRS --encryption-services blob
# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "RES_GRP: '$RESOURCE_GROUP_NAME'"
echo "STORAGE_ACCT: '$STORAGE_ACCOUNT_NAME'"
echo "CONTAINER_NAME: $CONTAINER_NAME"

