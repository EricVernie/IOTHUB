
param(    	
	[Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,
	
	[Parameter(Mandatory=$True)]
    [string]
    $IotHubName,
    
    [Parameter(Mandatory=$True)]
    [string]	
    $DeviceId	
	)
	
	try
	{
		Write-Host "Creating IOT Hub Device"
		Add-Type -Path ".\IOTHubInfo.cs"
		$IotHubInfo = New-Object IOtHubInfo
		
		#Get IOT Hub PrimaryKey
		$IothubTempoInfo=Get-AzureRmIotHubKey -ResourceGroupName $ResourceGroupName -Name $IotHubName -KeyName "iothubowner"
		
		$ConnectionString = "HostName="+$IotHubName+ ".azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey="+ $IothubTempoInfo.PrimaryKey
		
		$IotHubInfo.ConnectionString= $ConnectionString
		#Adding a Device
		$DeviceInfo=Add-CreateIOTHubDevice -ConnectionString $ConnectionString  -Name $DeviceId
		
		$IotHubInfo.DevicePrimaryKey = $DeviceInfo.Authentication.SymmetricKey.PrimaryKey
		Write-Host "Creating IOT Hub Device succeeded"
	}
	catch
	{
		.\ErrorHelper.ps1   "AddDevice.ps1"	 $($_.Exception.Message)	
	}
	
	return $IotHubInfo