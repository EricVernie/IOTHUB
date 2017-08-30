# Iot Hub Demo

The purpose of this demo, is to provide all the necessaries elements in order to:
1. Create the IOT Hub with template ARM and Powershell cmdlet
2. Simulate a device which send telemetry to the cloud (D2C)
3. Read the telemetry from the Device
4. Send message to the device (C2D)
5. Invoke direct method

For More information see [Connect your device to your IoT hub using .NET](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-csharp-csharp-getstarted)

To complete the demo, you need the following:

* Visual Studio 2017.
* An active Azure account. (If you don't have an account, you can create a [free account](http://azure.microsoft.com/pricing/free-trial/) in just a couple of minutes.)


# Project

after cloning the project

git clone https://github.com/EricVernie/IOTHUB.git

Open the IotHubLab solution in VS 2017 and build it

__SimulatedDevice__, 
1. Connects to your to your IoT hub with the device identity, and sends a telemetry message every second by using the AMQP protocol.
2. Receives message from cloud
3. Response to Direct Method (writeLine)




__CloudToDevice__
1. Displays the telemetry sent by your device app
2. Send a message to the Device
3. Invoke a direct method (writeLine)


__PowershellCmdLet__, allows to create a device in your Iot Hub

__DeploymentScript__, contains all necessaries Powershell scripts & ARM Templates to set up the IOT Hub Resources in your Azure Subscription



# Setup
If you have not installed Azure PowerShell, see [How to install and configure Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/overview?view=azurermps-4.3.1).

or access directly to the setup files:

[Azure PowerShell 4.3.1 Installer](https://github.com/Azure/azure-powershell/releases/download/v4.3.1-August2017/azure-powershell.4.3.1.msi)

[Gallery Module for ARM Cmdlets](https://www.powershellgallery.com/packages/AzureRM/4.3.1)


If you have installed Azure PowerShell in the past but have not updated it recently, consider installing the latest version. You can update the version through the same method you used to install it. For example, if you used the Web Platform Installer, launch it again and look for an update.

To check your version of the Azure Resources module, use the following cmdlet:


Get-Module -ListAvailable -Name AzureRm.Resources | Select Version

# Create Azure IOT Hub 

* Open a Powershell console in admin mode

* Go to the __DeploymentScript__ folder, and enter the following command:
  __.\StartDeployment.ps1__

    or

    __.\StartDeployment.ps1__ deployedCustomPowershell O Login O 

And fill the parameters:

_deployedCustomPowershell:_ O (O character) 

This parameter allows to set up the custom powershell command (PowershellCmdlet)

__Note:__ If you stay in the current powershell session the next time you execute the StartDeployment.ps1 script, no need to install again the Powershell command, so, enter 'N' or whatever except 'O'. 
The custom powershell set up must display the following message:

| Name        | PSVersion           | Description  |
| ------------- |:-------------:| -----:|
| CreateIotHubDevice     | 5.1| This CmdLet allow to create an IOTHub device |




_Login:_ O (O character) 

__Note:__ If you stay in the current powershell session the next time you execute the StartDeployment.ps1 script, no need to reenter your Azure credential, so, enter 'N' or whatever except 'O'

_deploymentName:_ [YOUR IOT HUB NAME DEPLOYMENT]


The set up start and do the following tasks:
1. Install the custom Powershell command (see __SetupCustomPowershellCmdlet.ps1__ script)
2. Log in with your azure credential (see __Login.ps1__ script)
3. Create an Azure Resource Group (see __Step1InvokeArmTemplate.ps1__ script)

	New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation 


	__Note__: By default the name of the resource group is a composition of the [YOUR IOT HUB NAME DEPLOYMENT] and .rg extension and the location is __North Europe__ (near my home)
4. Start the deployment to Azure using the __Step1template.json__ template

	New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;

5. Create a device in the Iot Hub

	Add-CreateIOTHubDevice -ConnectionString $connectionString  -Name $deviceId

To test the solution launch the console Apps:

SimulatedDevice.exe [IOT HUB NAME] [DEVICE KEY] [DEVICEID]

CloudTodevice.Exe [IOT Hub ConnectionString] [DEVICEID]

To delete the IOT HUB launch the script: 

.\Clean.ps1 [RESOURCE GROUP NAME]

__Remarks__: The template use as a pricing and scale tier 'free' and 'F1' which allows only __1 unit__. So you can create only 1 IOT Hub







