# TODO  Add SPN details and SSL certs to this key vault
# https://docs.microsoft.com/en-us/azure/key-vault/key-vault-manage-with-cli2

KV_NAME=$1
RESOURCE_GROUP_NAME=$2

az keyvault create --resource-group $RESOURCE_GROUP_NAME --name $KV_NAME

# #TODO - set policy and Store SPN information in platformkv
# # set policy for platform admin team
# # https://docs.microsoft.com/en-us/cli/azure/keyvault?view=azure-cli-latest#az-keyvault-set-policy
# # store tf provisioner secret app id objectid
# #   Allow tf provisioner access to read key and secrets


# e.g.
# az keyvault key import --vault-name "ContosoKeyVault" --name "ContosoFirstKey" --pem-file "./softkey.pem" --pem-password "hVFkk965BuUv" --protection software
# az keyvault certificate import --vault-name "ContosoKeyVault" --file "c:\cert\cert.pfx" --name "ContosoCert" --password "hVFkk965BuUv"
# az keyvault secret set --vault-name "ContosoKeyVault" --name "SQLPassword" --value "hVFkk965BuUv "