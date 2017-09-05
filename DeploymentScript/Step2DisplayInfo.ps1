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
    
	Write-Host "IOTHub Name:                   '$IotHubName'"
	Write-Host ""
	Write-Host "IOT Hub ConnectionString:      '$ConnectionString'"
	Write-Host ""
	Write-Host "Device PrimaryKey:             '$DevicePrimaryKey'"
	Write-Host ""
	Write-Host "Consumer Group:                '$IotHubConsumerGroup'"
	Write-Host ""
	Write-Host "Event Hub-compatible endpoint: '$IotHubEventCompatibleEndPoint'"

	Write-Host "Verify Send/Received Telemetry"
	Write-Host "1. Launch the console App to send telemetry: .\SimulatedDevice.exe '$IotHubName' '$DevicePrimaryKey' '$DeviceId'"	
	Write-Host "2. Launch the console App to received telemetry:.\CloudTodevice.Exe '$ConnectionString'  '$DeviceId' '$IotHubConsumerGroup'"

	Write-Host ""
	Write-Host "Verify your message in your table storage"	
	Write-Host "3. Download and install Azure Storage Explorer(https://azure.microsoft.com/en-us/features/storage-explorer/)"
	Write-Host "4. Open Storage Explorer, click Add an Azure Account > Sign in, and then sign in to your Azure account."
	Write-Host "5. Click your Azure subscription > Storage Accounts > your storage account > Tables > deviceData"


	