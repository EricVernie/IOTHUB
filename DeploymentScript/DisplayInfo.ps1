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
	 $IotHubConsumerGroup
	)
 
	Write-Host "IOTHub Name: '$IotHubName'"
	Write-Host ""
	Write-Host "IOT Hub ConnectionString: '$ConnectionString'"
	Write-Host ""
	Write-Host "Device PrimaryKey: '$DevicePrimaryKey'"
	Write-Host ""
	Write-Host "To simulate a Device execute the following command: .\SimulatedDevice.exe '$IotHubName' '$DevicePrimaryKey' '$DeviceId'"
	Write-Host ""
	Write-Host "Execute the following command to capture the message from a Device .\CloudTodevice.Exe '$ConnectionString'  '$DeviceId' '$IotHubConsumerGroup'"