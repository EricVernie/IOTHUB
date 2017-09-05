 param(    
	
	[Parameter(Mandatory=$True)]
    [string]	
    $ResourceGroupName,

	[Parameter(Mandatory=$True)]
    [string]	
	$IotHubName,

    [Parameter(Mandatory=$True)]
    [string]	
    $DeviceId,

	[Parameter(Mandatory=$True)]
    [string]	
    $DevicePrimaryKey,

	[Parameter(Mandatory=$True)]
    [string]	
    $ConnectionString,
	
	
    [string]	
	 $IotHubConsumerGroup,

	 [string]
	 $IotHubEventCompatibleEndPoint
	)
    
	Write-Host "IOTHub Name: '$IotHubName'"
	Write-Host ""
	Write-Host "IOT Hub ConnectionString: '$ConnectionString'"
	Write-Host ""
	Write-Host "Device PrimaryKey: '$DevicePrimaryKey'"
	Write-Host ""
	
	Write-Host ""
	Write-Host "Event Hub-compatible endpoint: '$IotHubEventCompatibleEndPoint'"
		

	Write-Host ""
	Write-Host "Verify your message in your table storage"
	Write-Host "1. Launch the console App: .\SimulatedDevice.exe '$IotHubName' '$DevicePrimaryKey' '$DeviceId'"
	Write-Host "2. Download and install Azure Storage Explorer(https://azure.microsoft.com/en-us/features/storage-explorer/)"
	Write-Host "3. Open Storage Explorer, click Add an Azure Account > Sign in, and then sign in to your Azure account."
	Write-Host "4. Click your Azure subscription > Storage Accounts > your storage account > Tables > deviceData"


	