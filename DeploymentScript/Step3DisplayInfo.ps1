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
	 $WebAppName
	)
    
	Write-Host "To Test:"
	Write-Host ""
	Write-Host "1. Launch the console App to send telemetry: .\SimulatedDevice.exe '$IotHubName' '$DevicePrimaryKey' '$DeviceId'"
	$WebAppUrl = "http://$WebAppName.azurewebsites.net"
	Write-Host "2. In any browser type the url to vizualize the telemetry: " + $WebAppUrl 
	
