 param(    
	
	[Parameter(Mandatory=$True)]
    [string]	
    $resourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]	
    $deviceId	

	)
	Write-Host "Step2 Finishing...."
   
	#Get the IOTHubName From the deployment OutPut
	$IotHubNameInfo= Get-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName	
    $IotHubConsumerGroup=$IotHubNameInfo.Outputs["outputConsumerGroup"].Value
	
	
	$IotHubInfo = Invoke-Expression ".\AddDevice.ps1 '$ResourceGroupName' '$DeviceId'" 
    $DevicePrimaryKey =$IotHubInfo.DevicePrimaryKey
    $ConnectionString = $IotHubInfo.ConnectionString
    $IotHubName = $IotHubInfo.IotHubName

   
    Invoke-Expression ".\DisplayInfo.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId' '$DevicePrimaryKey' '$ConnectionString' '$IotHubConsumerGroup'"
   