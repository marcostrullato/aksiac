# Bash script to run through all the set up scripts in this folder
#
# Make sure that the subscription has the correct upper limit set for the Machine SKUs that will run.
#e.g. If 50 CPU is needed for D series machines this should be requested on set up of the subscription. this can be done by raising a support ticket in azure portal

# VARIABLES
project=""
SPN_TERRAFORM=$project-tfprovisioner
RESOURCE_GROUP_NAME=$project-platform-rg
RESOURCE_GROUP_LOCATION=${1:-"westeurope"}

# can use this for acr, storage
ACR_NAME="${project//-}"acr
STORAGE_ACCOUNT_NAME="${project//-}"platformstr
KV_NAME="${project//-}"platformkv

# ===================================================

#az login

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $RESOURCE_GROUP_LOCATION

# Create the platform Resource Group

source 1_create_tf_service_principal.sh $SPN_TERRAFORM
source 2_create_storage_for_tfstate.sh $STORAGE_ACCOUNT_NAME $RESOURCE_GROUP_NAME
source 3_create_acr.sh $ACR_NAME $RESOURCE_GROUP_NAME $APPID 
source 4_create_keyvault.sh $KV_NAME $RESOURCE_GROUP_NAME
