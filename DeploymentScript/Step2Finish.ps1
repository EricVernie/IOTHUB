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
	$SiteFuncName = $ResourceGroupeDeploymentOutPut.Outputs["outputSiteFuncName"].Value
	
	#Get the events endPoint By Powershell (Obsolete see the outputs template to do that)
	#$IotHubOutputInfo=$ResourceGroupeDeployment.Outputs["iotHubInfo"]
	#$EventHubEndPoints=$IotHubOutputInfo.Value["eventHubEndpoints"]
	#$Event = $EventHubEndPoints["events"]
	#$EndPointEvent=$Event | Where-Object Name -eq "endPoint"
	#$EndPointEventValue=$EndPointEvent| Select -Property Value
	#$EndPointEventValue.Value
	
	#Create the device on the IotHub
	$IotHubInfo = Invoke-Expression ".\AddDevice.ps1 '$ResourceGroupName' '$DeviceId'" 
    $DevicePrimaryKey =$IotHubInfo.DevicePrimaryKey
    $ConnectionString = $IotHubInfo.ConnectionString
    $IotHubName = $IotHubInfo.IotHubName

	#Create the function.json file before the deployment of the function
	Invoke-Expression ".\Step2DeployingFunction.ps1 '$ResourceGroupName' '$IotHubName' '$SiteFuncName' '$IotHubConsumerGroup'"
	
   
    Invoke-Expression ".\DisplayInfo.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId' '$DevicePrimaryKey' '$ConnectionString' '$IotHubConsumerGroup'"
    Write-Host ""
	Write-Host "Event Hub-compatible endpoint: '$IotHubEventCompatibleEndPoint'"
	