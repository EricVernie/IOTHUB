 param(    
	
	[Parameter(Mandatory=$True)]
    [string]	
    $ResourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]	
    $DeviceId	

	)
	Write-Host "Step3 Finishing...."   
	
	
   
   $ResourceGroupeDeploymentOutPut= Get-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name Step3Template
   $IotHubConsumerGroup=$ResourceGroupeDeploymentOutPut.Outputs["outputConsumerGroup"].Value
   $WebAppName=$ResourceGroupeDeploymentOutPut.Outputs["outputWebAppName"].Value
   $IotHubName = $ResourceGroupeDeploymentOutPut.Outputs["outputIotHubName"].Value; 
   

   $IotHubInfo = Invoke-Expression ".\AddDevice.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId'" 
   $DevicePrimaryKey =$IotHubInfo.DevicePrimaryKey
   $ConnectionString = $IotHubInfo.ConnectionString
   

    Write-Host "The Setup is almost done"
	Write-Host "BEFORE TO CONTINUE DO THE FOLLOWING:"
	Write-Host "=============================================="
	Write-Host "1. Sign in to http://portal.azure.com."
	Write-Host "2. Select the resource group you just create."
	Write-Host "3. Select the Web App."
	Write-Host "4. In the Web app Select Deployment Options > Choose Source > Local Git Repository, and the click OK."   
	Write-Host "5. Click Deployment Credentials, create a user name and password to use to connect to the Git repository in Azure, and then click Save."
	Write-Host "6. Click Overview, and copy the value of Git clone url."
	Write-Host "7. Then press any key to continue"
	Write-Host "==============================================="
	
	write-host "Press any key to continue..."
	[void][System.Console]::ReadKey($true)
	.\Step3DeployWebApp.ps1
   
    Invoke-Expression ".\Step3DisplayInfo.ps1 '$ResourceGroupName' '$IotHubName' '$DeviceId' '$DevicePrimaryKey' '$WebAppName'"
   