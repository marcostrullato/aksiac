#!/bin/bash
# TODO Configure push pull permission for spn-terraform-provisioner

ACR_NAME=$1
RESOURCE_GROUP_NAME=$2
SERVICE_PRINCIPAL_ID=$3

az acr create --resource-group $RESOURCE_GROUP_NAME --name $ACR_NAME --sku Premium

# Populate value required for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Assign the desired role to the service principal. Modify the '--role' argument
# value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
if [ -z "$SERVICE_PRINCIPAL_ID" ]
then
      echo "Service principal not provided"
else
        # owner to be granted to the terraform provisioner spn.  This will need to be able to grant role access to the spn aks cluster 
        # when the terraform creates the spn aks cluster
      az role assignment create --assignee $SERVICE_PRINCIPAL_ID --scope $ACR_REGISTRY_ID --role owner
      echo "Assigned Service principal access to ACR"
fi


