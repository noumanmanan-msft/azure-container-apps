# Import variables
. variables.sh

# Login
az login

# Create resource group
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# Install the AZ Cli ContainerApps extension
az extension add \
  --source https://workerappscliextension.blob.core.windows.net/azure-cli-extension/containerapp-0.2.4-py2.py3-none-any.whl

# Currently Container Apps are under Microsoft.Web but are being migrated to Microsoft.App
az provider register --namespace Microsoft.Web

# Create Log Analytics workspace
az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --workspace-name $LOG_ANALYTICS_WORKSPACE

LOG_ANALYTICS_WORKSPACE_CLIENT_ID=$(az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)

LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=$(az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)

# Create Container Apps environment
az containerapp env create \
  --name $CONTAINERAPPS_ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID \
  --logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET \
  --location $LOCATION

# Create the Container Apps
az containerapp create \
  --name $CONTAINERAPP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINERAPPS_ENVIRONMENT \
  --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
  --target-port 80 \
  --ingress 'external'

