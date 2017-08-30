param(    
	[Parameter(Mandatory=$True)]
    [string]
    $deploymentName,

    #[Parameter(Mandatory=$True)]
    [string]
    $resourceGroupName = $deploymentName+"-rg",
   
	#[Parameter(Mandatory=$True)]
    [string]
    $resourceGroupLocation="North Europe",
   
	#[Parameter(Mandatory=$True)]
	#[string]
	#$iothubName,

	#[Parameter(Mandatory=$True)]
	[string]
	$deviceId="Device42",

    [string]
    $templateFilePath = "Step1template.json",
   
    [string]
    $parametersFilePath = "Step1parameters.json"
   )

    <#
   .SYNOPSIS
       Registers RPs
   #>
   Function RegisterRP {
       Param(
           [string]$ResourceProviderNamespace
       )
   
       Write-Host "Registering resource provider '$ResourceProviderNamespace'";
       Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
   }
   
   #******************************************************************************
   # Script body
   # Execution begins here
   #******************************************************************************
   $ErrorActionPreference = "Stop";

   # Register RPs
   $resourceProviders = @("microsoft.devices");
   if($resourceProviders.length) {
       Write-Host "Registering resource providers"
       foreach($resourceProvider in $resourceProviders) {
           RegisterRP($resourceProvider);
       }
   }
   
   #Create or check for existing resource group
   $resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
   if(!$resourceGroup)
   {
       Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
       if(!$resourceGroupLocation) {
           $resourceGroupLocation = Read-Host "resourceGroupLocation";
       }
       Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
       New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation 
   }
   else{
       Write-Host "Using existing resource group '$resourceGroupName'";
   }
   
   # Start the deployment using template
   Write-Host "Starting deployment...";
  
		   #if(Test-Path $parametersFilePath) {
	   #    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath;
	   #} else {
		 $IotHubNameInfo=  New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;
	   #}
  #Get the IOTHubName  From the deployment OutPut
   $iothubName=$IotHubNameInfo.Outputs["outputIotHubName"].Value;

   #Get IOT HUb PrimaryKey
  $iothubinfo=Get-AzureRmIotHubKey -ResourceGroupName $resourceGroupName -Name $iothubName -KeyName "iothubowner"
   
   
   Write-Host "Creating IOT Hub Device"
   #Construct the ConnectionString
   $connectionString = "HostName="+$iothubName+".azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey="+$iothubinfo.PrimaryKey
   
   $deviceInfo=Add-CreateIOTHubDevice -ConnectionString $connectionString  -Name $deviceId
   
   Write-Host "IOTHub Name:" $iothubName
   Write-Host "IOT Hub ConnectionString: "  $connectionString
   Write-Host "Device PrimaryKey: "   $deviceInfo.Authentication.SymmetricKey.PrimaryKey   
   
   Write-Host "To simulate a Device execute the following command: .\SimulatedDevice.exe " $iothubName  $deviceInfo.Authentication.SymmetricKey.PrimaryKey $deviceId  
   Write-Host "Execute the following command to capture the message from a Device .\CloudTodevice.Exe" $connectionString  $deviceId 