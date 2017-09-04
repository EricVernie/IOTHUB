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
	$ResourceGroupeDeploymentOutPut= Get-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName	
    $IotHubConsumerGroup=$ResourceGroupeDeploymentOutPut.Outputs["outputConsumerGroup"].Value
	
	$IotHubEventCompatibleEndPoint=$ResourceGroupeDeploymentOutPut.Outputs["outputIotHubEventConnectionString"].Value
	#Get the events endPoint By Powershell (Obsolete see the outputs template to do that)
	#$IotHubOutputInfo=$ResourceGroupeDeployment.Outputs["iotHubInfo"]
	#$EventHubEndPoints=$IotHubOutputInfo.Value["eventHubEndpoints"]
	#$Event = $EventHubEndPoints["events"]
	#$EndPointEvent=$Event | Where-Object Name -eq "endPoint"
	#$EndPointEventValue=$EndPointEvent| Select -Property Value
	#$EndPointEventValue.Value
	
	
	$IotHubInfo = Invoke-Expression ".\AddDevice.ps1 '$ResourceGroupName' '$DeviceId'" 
    $DevicePrimaryKey =$IotHubInfo.DevicePrimaryKey
    $ConnectionString = $IotHubInfo.ConnectionString
    $IotHubName = $IotHubInfo.IotHubName

   
    Invoke-Expression ".\DisplayInfo.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId' '$DevicePrimaryKey' '$ConnectionString' '$IotHubConsumerGroup'"
    
	Write-Host "Event Hub-compatible endpoint: '$IotHubEventCompatibleEndPoint'"
	