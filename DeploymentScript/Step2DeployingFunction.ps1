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
								 consumerGroup=''
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

$json=ConvertTo-Json $FunctionBinding
$json | Out-File '.\FunctionAsset\Step2CustomFunction\function.json'

Write-Host "Ziping the files..."
$functionPath=".\FunctionAsset\"
$outputPath=".\FunctionAsset\Step2CustomFunction.zip"
$excluded = @(".vscode", ".gitignore", "appsettings.json", "secrets")
$include = Get-ChildItem $functionPath -Exclude $excluded
Compress-Archive -Path $include -Update -DestinationPath $outputPath

Write-Host "Getting the user credentials..."
$creds = Invoke-AzureRmResourceAction -ResourceGroupName $ResourceGroupName -ResourceType Microsoft.Web/sites/config `
            -ResourceName $FuncAppName/publishingcredentials -Action list -ApiVersion 2015-08-01 -Force

$username = $creds.Properties.PublishingUserName
$password = $creds.Properties.PublishingPassword

Write-Host "Copying files to Function App site.."
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$apiUrl = "https://" + $FuncAppName+ ".scm.azurewebsites.net/api/zip/site/wwwroot"
$apiUrl
Invoke-RestMethod -Uri $apiUrl -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Method PUT -InFile $outputPath -ContentType "multipart/form-data"



