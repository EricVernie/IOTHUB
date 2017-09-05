 param(    
	
	[Parameter(Mandatory=$True)]
    [string]	
    $ResourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]	
    $DeviceId	

	)
	Write-Host "Step3 Finishing...."   
	
	
   $IotHubInfo = Invoke-Expression ".\AddDevice.ps1 '$ResourceGroupName' '$DeviceId'" 
   $DevicePrimaryKey =$IotHubInfo.DevicePrimaryKey
   $ConnectionString = $IotHubInfo.ConnectionString
   $IotHubName = $IotHubInfo.IotHubName

   $ResourceGroupeDeploymentOutPut= Get-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName	
    $IotHubConsumerGroup=$ResourceGroupeDeploymentOutPut.Outputs["outputConsumerGroup"].Value
   
   Invoke-Expression ".\Step3DisplayInfo.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId' '$DevicePrimaryKey' '$ConnectionString' '$IotHubConsumerGroup'"
   