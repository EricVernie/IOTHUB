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
    $ConnectionString
	)
    
	Write-Host "IOTHub Name: '$IotHubName'"
	Write-Host ""
	Write-Host "IOT Hub ConnectionString: '$ConnectionString'"
	Write-Host ""
	Write-Host "Device PrimaryKey: '$DevicePrimaryKey'"
	Write-Host ""
	
	Write-Host "Verify Send/Received Telemetry"
	Write-Host "1. Launch the console App to send telemetry: .\SimulatedDevice.exe '$IotHubName' '$DevicePrimaryKey' '$DeviceId'"	
	Write-Host "2. Launch the console App to received telemetry:.\CloudTodevice.Exe '$ConnectionString'  '$DeviceId'"