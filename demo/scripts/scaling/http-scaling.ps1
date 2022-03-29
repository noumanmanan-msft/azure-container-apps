$totalMessages = 1

1..$totalMessages | ForEach-Object -Parallel { 
    $response = Invoke-WebRequest -URI "https://ca-generaldemo-eastus2-001.thankfulsmoke-704adc34.eastus2.azurecontainerapps.io/"
    Write-host $response.StatusCode $response.StatusDescription
} -ThrottleLimit 10