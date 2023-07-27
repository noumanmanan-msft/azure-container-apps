containerAppJobName="ca-job-001"
resourceGroupName="rg-demo-scus-001"
environmentName="ca-env-demo-scus-001"
connectionStringSecret="connection-string-secret"
queueName="myqueue"
queueConnectionString="<QUEUE_CONNECTION_STRING>"
queueAccountName="mystorage"
location="southcentralus"

az containerapp env create \
    --name "$environmentName" \
    --resource-group "$resourceGroupName" \
    --location "$location"

az containerapp job create \
    --name "$containerAppJobName" --resource-group "$resourceGroupName"  --environment "$environmentName" \
    --trigger-type "Manual" \
    --replica-timeout 1800 --replica-retry-limit 1 --replica-completion-count 1 --parallelism 1 \
    --image "mcr.microsoft.com/k8se/quickstart-jobs:latest" \
    --cpu "0.25" --memory "0.5Gi"

az containerapp job start \
    --name "$containerAppJobName" \
    --resource-group "$resourceGroupName"

az containerapp job execution list \
    --name "$containerAppJobName" \
    --resource-group "$resourceGroupName" \
    --output table \
    --query '[].{Status: properties.status, Name: name, StartTime: properties.startTime}'

logAnalyticsWorkspaceId=`az containerapp env show \
    --name "$environmentName" \
    --resource-group "$resourceGroupName" \
    --query "properties.appLogsConfiguration.logAnalyticsConfiguration.customerId" \
    --output tsv`

containerAppJobExecName=`az containerapp job execution list \
    --name "$containerAppJobName" \
    --resource-group "$resourceGroupName" \
    --query "[0].name" \
    --output tsv`

az monitor log-analytics query \
    --workspace "$logAnalyticsWorkspaceId" \
    --analytics-query "ContainerAppConsoleLogs_CL | where ContainerGroupName_s startswith '$containerAppJobName' | order by _timestamp_d asc" \
    --query "[].Log_s"

az monitor log-analytics query \
    --workspace "0a4dafb6-2eca-43c6-b382-d91b1ed5679d" \
    --analytics-query "ContainerAppConsoleLogs_CL | where ContainerGroupName_s startswith '$containerAppJobName' | order by _timestamp_d asc" \
    --query "[].Log_s"