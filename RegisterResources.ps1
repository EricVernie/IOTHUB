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

   # Register RPs
   $resourceProviders = @("microsoft.devices");
   if($resourceProviders.length) {
       Write-Host "Registering resource providers"
       foreach($resourceProvider in $resourceProviders) {
           RegisterRP($resourceProvider);
       }
   }