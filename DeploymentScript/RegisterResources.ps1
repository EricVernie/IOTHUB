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
   $ResourceProviders = @("microsoft.devices","microsoft.storage","microsoft.web");
   if($ResourceProviders.length) {
       Write-Host "Registering resource providers"
       foreach($ResourceProvider in $ResourceProviders) {
           RegisterRP($ResourceProvider);
       }
   }