param(
	[Parameter(Mandatory=$True)]
    [string]	
    $GitCloneUrl	
)
$OutPutPath = ".\web-apps-node-iot-hub-data-visualization"
if (Test-Path $OutPutPath)
{
	Remove-Item $OutPutPath
}
git clone https://github.com/Azure-Samples/web-apps-node-iot-hub-data-visualization.git
cd .\web-apps-node-iot-hub-data-visualization\
git remote add webapp $GitCloneUrl

git push webapp master:master

cd ..
Write-Host "Deploying web app finished"
 
