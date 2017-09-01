 param(    
	
	[Parameter(Mandatory=$True)]
    [string]	
    $ResourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]	
    $DeviceId	

	)
	Write-Host "Step1 Finishing...."   
	
	
   $IotHubInfo = Invoke-Expression ".\AddDevice.ps1 '$ResourceGroupName' '$DeviceId'" 
   $DevicePrimaryKey =$IotHubInfo.DevicePrimaryKey
   $ConnectionString = $IotHubInfo.ConnectionString
   $IotHubName = $IotHubInfo.IotHubName

   
   Invoke-Expression ".\DisplayInfo.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId' '$DevicePrimaryKey' '$ConnectionString'"
   