 param(    
	[Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,
  
	[Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupLocation
   
   )
  #Create or check for existing resource group
   $ResourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
   if(!$resourceGroup)
   {
       Write-Host "Resource group '$ResourceGroupName' does not exist. Create a new resource group, location: '$ResourceGroupLocation'";       
       Write-Host "Creating resource group '$ResourceGroupName' in location '$ResourceGroupLocation'";
       New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation 
   }
   else{
       Write-Host "Using existing resource group '$ResourceGroupName'";
   }
