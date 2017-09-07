 param(    
	
	[Parameter(Mandatory=$True)]
    [string]	
    $ResourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]	
    $DeviceId	

	)
	Write-Host "Step2 Finishing...."
    try
	{
	#Get the IOTHubName From the deployment OutPut
	$ResourceGroupeDeploymentOutPut= Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -Name Step2template
    $IotHubConsumerGroup=$ResourceGroupeDeploymentOutPut.Outputs["outputConsumerGroup"].Value
	$IotHubName = $ResourceGroupeDeploymentOutPut.Outputs["outputIotHubName"].Value; 

	$IotHubEventCompatibleEndPoint=$ResourceGroupeDeploymentOutPut.Outputs["outputIotHubEventConnectionString"].Value
	$SiteFuncName = $ResourceGroupeDeploymentOutPut.Outputs["outputSiteFuncName"].Value
	$AzureFuncStorageName =$ResourceGroupeDeploymentOutPut.Outputs["outputAzureFuncStorageName"].Value
	$StorageAccountKey =$ResourceGroupeDeploymentOutPut.Outputs["outputStorageAccountKey"].Value
	
	#Create the device on the IotHub
	$IotHubInfo = Invoke-Expression ".\AddDevice.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId'" 
    $DevicePrimaryKey =$IotHubInfo.DevicePrimaryKey
    $ConnectionString = $IotHubInfo.ConnectionString
    
	#Create the deviceData Table
	Write-Host "Creating Table 'deviceData' on '$AzureFuncStorageName'"
	$Ctx = New-AzureStorageContext -StorageAccountName $AzureFuncStorageName -StorageAccountKey $StorageAccountKey
	New-AzureStorageTable -Name 'deviceData' -Context $Ctx

	#Create the function.json file before the deployment of the function
	Invoke-Expression ".\Step2DeployingFunction.ps1 '$ResourceGroupName' '$IotHubName' '$SiteFuncName' '$IotHubConsumerGroup'"	   
    
	Invoke-Expression ".\Step2DisplayInfo.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId' '$DevicePrimaryKey' '$ConnectionString' '$IotHubConsumerGroup' '$IotHubEventCompatibleEndPoint'"
    
	}
	catch
	{
		.\ErrorHelper.ps1   "Step2Finish.ps1"	 $($_.Exception.Message)
	}
	