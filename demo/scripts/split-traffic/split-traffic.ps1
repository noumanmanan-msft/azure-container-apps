for($i=0; $i -lt 50; $i++)
{
    curl https://ca-demo-app-eastus-001.whitewater-eccf82c4.eastus.azurecontainerapps.io/ | Select-String -Pattern "containerapp"
}

