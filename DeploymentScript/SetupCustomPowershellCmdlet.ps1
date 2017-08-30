#Setup the Powershell command in order
 #installing powershell command
   Write-Host "Installing custom powershell command"
   #load powershell 64 admin mode
   #register the CmdLet
   C:\Windows\Microsoft.NET\Framework64\v4.0.30319\installutil.exe PowershellCmdLet.dll
   #verify
   get-PSsnapin -registered
   #You get
   #Name        : CreateIotHubDevice
   #PSVersion   : 5.1
   #Description : This CmdLet allow to create a IOTHub device
   
   #add the snapin
   Add-PSSnapin CreateIOTHubDevice
   Write-Host "setup finished"