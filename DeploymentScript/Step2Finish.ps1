 param(    
	
	[Parameter(Mandatory=$True)]
    [string]	
    $resourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]	
    $deviceId	

	)
	Write-Host "Step2 Finishing...."
   
	#Get the IOTHubName From the deployment OutPut
	$IotHubNameInfo= Get-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName
	
    $iothubName=$IotHubNameInfo.Outputs["OutputIotHubName"].Value;
    $iothubConsumerGroup=$IotHubNameInfo.Outputs["OutputConsumerGroup"].Value
	#Get IOT Hub PrimaryKey
   $iothubinfo=Get-AzureRmIotHubKey -ResourceGroupName $resourceGroupName -Name $iothubName -KeyName "iothubowner"

   
   
   Write-Host "Creating IOT Hub Device"
   #Construct the ConnectionString
   $connectionString = "HostName="+$iothubName+".azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey="+$iothubinfo.PrimaryKey
   #Adding a Device
   $deviceInfo=Add-CreateIOTHubDevice -ConnectionString $connectionString  -Name $deviceId
   
   Write-Host "IOTHub Name: '$iothubName'"
   Write-Host "IOT Hub ConnectionString: '$connectionString'"
   Write-Host "Device PrimaryKey: '$deviceInfo.Authentication.SymmetricKey.PrimaryKey'"
   
   Write-Host "To simulate a Device execute the following command: .\SimulatedDevice.exe '$iothubName' '$deviceInfo.Authentication.SymmetricKey.PrimaryKey' '$deviceId'"
   Write-Host "Execute the following command to capture the message from a Device .\CloudTodevice.Exe '$connectionString'  '$deviceId' '$iothubConsumerGroup'"