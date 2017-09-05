param(
	[Parameter(Mandatory=$True)]
    [string]	
    $ResourceGroupName,

	[Parameter(Mandatory=$True)]
    [string]	
    $IotHubName,
	
	[Parameter(Mandatory=$True)]
    [string]	
    $FuncAppName,

	[Parameter(Mandatory=$True)]
    [string]	
    $ConsumerGroup

	)
#Creating the function.json
Write-Host "Deploying Function..."
Write-Host "Creating the Function.json file..."
Add-Type -Path ".\FunctionBindingsModel.cs"
$FunctionBinding = New-Object Function
$FunctionBinding.disabled=$false
$FunctionBinding.bindings = @{
								 type='eventHubTrigger';
								 name= 'eventHubMessages';
								 direction='in';								 
								 connection='EVENTS_IOTHUB_CONNECTION_STRING';
								 cardinality='many';								 
							 },
							 @{
								 type='table';
								 name='outputTable';
								 tableName='deviceData';
								 connection='STORAGE__CONNECTION_STRING';
								 direction='out'
							 }


$FunctionBinding.bindings[0].path=$IotHubName
$FunctionBinding.bindings[0].consumerGroup=$ConsumerGroup

$JsonFunctionBinding=ConvertTo-Json $FunctionBinding
$FunctionFilePath = '.\FunctionAsset\Step2CustomFunction\function.json'
if (Test-path $FunctionFilePath)
{
    Remove-Item $FunctionFilePath
}

#Write the json to the file
$JsonFunctionBinding | Out-File $FunctionFilePath

Write-Host "Ziping the files..."
$PathToZip=".\FunctionAsset\"
$OutputPathZip=".\FunctionAsset\Step2CustomFunction.zip"
if (Test-Path $OutputPathZip)
{
	Remove-Item -Path $OutputPathZip
}
$Excluded = @(".vscode", ".gitignore", "appsettings.json", "secrets")
$Include = Get-ChildItem $PathToZip -Exclude $Excluded
Compress-Archive -Path $Include -Update -DestinationPath $OutputPathZip

Write-Host "Getting the user credentials..."
$Creds = Invoke-AzureRmResourceAction -ResourceGroupName $ResourceGroupName -ResourceType Microsoft.Web/sites/config `
            -ResourceName $FuncAppName/publishingcredentials -Action list -ApiVersion 2015-08-01 -Force

$Username = $Creds.Properties.PublishingUserName
$Password = $Creds.Properties.PublishingPassword

Write-Host "Copying files to Function App site.."
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username,$Password)))
#Format the KUDU Api Url
$ApiUrl = "https://" + $FuncAppName+ ".scm.azurewebsites.net/api/zip/site/wwwroot"

Invoke-RestMethod -Uri $ApiUrl -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Method PUT -InFile $OutputPathZip -ContentType "multipart/form-data"

Write-Host "Deploying Function Succeeded"

