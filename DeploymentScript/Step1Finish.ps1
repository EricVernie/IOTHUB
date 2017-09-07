 param(    
	
	[Parameter(Mandatory=$True)]
    [string]	
    $ResourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]	
    $DeviceId	

	)
	Write-Host "Step1 Finishing...."   
	#Get the IOTHub info From the deployment OutPut
	$IotHubNameInfo= Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -Name Step1Template
	$IotHubName = $IotHubNameInfo.Outputs["outputIotHubName"].Value; 
	
   $IotHubInfo = Invoke-Expression ".\AddDevice.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId'" 
   $DevicePrimaryKey =$IotHubInfo.DevicePrimaryKey
   $ConnectionString = $IotHubInfo.ConnectionString
   

   
   Invoke-Expression ".\Step1DisplayInfo.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId' '$DevicePrimaryKey' '$ConnectionString'"
   