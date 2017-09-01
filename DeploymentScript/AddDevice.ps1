
param(    	
	[Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,
	
    
    [Parameter(Mandatory=$True)]
    [string]	
    $DeviceId	
	)
	
	try
	{
		Add-Type -Path ".\IOTHubInfo.cs"
		$IotHubInfo = New-Object IOtHubInfo
		#Get the IOTHub info From the deployment OutPut
		$IotHubNameInfo= Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName	
		$IotHubInfo.IotHubName = $IotHubNameInfo.Outputs["outputIotHubName"].Value;    
		#$IotHubInfo.ConsumerGroup=$IotHubNameInfo.Outputs["outputConsumerGroup"].Value
		
		#Get IOT Hub PrimaryKey
		$IothubTempoInfo=Get-AzureRmIotHubKey -ResourceGroupName $ResourceGroupName -Name $IotHubInfo.IotHubName -KeyName "iothubowner"
		
		Write-Host "Creating IOT Hub Device"

		$ConnectionString = "HostName="+$IotHubInfo.IotHubName+ ".azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey="+ $IothubTempoInfo.PrimaryKey
		
		$IotHubInfo.ConnectionString= $ConnectionString
		#Adding a Device
		$DeviceInfo=Add-CreateIOTHubDevice -ConnectionString $ConnectionString  -Name $DeviceId
		
		$IotHubInfo.DevicePrimaryKey = $DeviceInfo.Authentication.SymmetricKey.PrimaryKey
	
	}
	catch
	{
		.\ErrorHelper.ps1   "AddDevice.ps1"	 $($_.Exception.Message)	
	}
	
	return $IotHubInfo