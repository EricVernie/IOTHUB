 param(    
	[Parameter(Mandatory=$True)]
    [string]
    $resourceGroupName,
  
	[Parameter(Mandatory=$True)]
    [string]
    $resourceGroupLocation
   
   )
  #Create or check for existing resource group
   $resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
   if(!$resourceGroup)
   {
       Write-Host "Resource group '$resourceGroupName' does not exist. Create a new resource group, location: '$resourceGroupLocation'";       
       Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
       New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation 
   }
   else{
       Write-Host "Using existing resource group '$resourceGroupName'";
   }
