#!/bin/bash
SPN_NAME=$1
echo "$SPN_NAME"

SERVICEPRINCIPAL_NAME=${1:-"http://$SPN_NAME"} 
echo "$SERVICEPRINCIPAL_NAME"

echo "Creating Pipeline Service Principal..."
export SP_PASSWORD=$(az ad sp create-for-rbac --name $SERVICEPRINCIPAL_NAME --skip-assignment --query password --output tsv)

echo "Waiting 60 seconds..."
sleep 60s

# get subscription details
SUBSCRIPTION_ID=$(az account show | jq -r .id)
SUBSCRIPTION_NAME=$(az account show | jq -r .name)

echo "Applying Contributor OR any other User Access Administrator roles"
az role assignment create --role "Owner" --assignee $SERVICEPRINCIPAL_NAME --scope /subscriptions/$SUBSCRIPTION_ID
#az role assignment create --role "Contributor" --assignee $SERVICEPRINCIPAL_NAME --scope /subscriptions/$SUBSCRIPTION_ID
#az role assignment create --role "User Access Administrator" --assignee $SERVICEPRINCIPAL_NAME --scope /subscriptions/$SUBSCRIPTION_ID

export OBJECT_ID=$(az ad sp show --id $SERVICEPRINCIPAL_NAME --query objectId --output tsv)
export APPID=$(az ad sp show --id $SERVICEPRINCIPAL_NAME --query appId --output tsv)

echo "Complete service princial creation!"