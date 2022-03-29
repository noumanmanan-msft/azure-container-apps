# Import variables
. variables.sh

# Delete resource group
az group delete --name $RESOURCE_GROUP
