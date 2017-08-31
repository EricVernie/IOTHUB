param(  
	[Parameter(Mandatory=$True)]
	[string]
	$Step,
	
	[Parameter(Mandatory=$True)]
    [string]
    $deploymentName,
   
	[string]
    $templateFilePath=$Step +"template.json",
	

    [string]
    $resourceGroupName = $deploymentName+"-rg",
   
	
    [string]
    $resourceGroupLocation="North Europe",
   
	[string]
	$deviceId="Device42"
   )


   Invoke-Expression '.\RegisterResources.ps1'
   
   $Command = ".\CreateResourceGroup.ps1 '$resourceGroupName' '$resourceGroupLocation'"
   Invoke-Expression $Command

   # Start the deployment using template
   Write-Host "Starting deployment...";  
   New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;	
   
  

   $StepFinish =".\'$Step'Finish.ps1 '$resourceGroupName' '$deviceId'"
   
   Invoke-Expression  $StepFinish 
