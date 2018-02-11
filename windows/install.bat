@echo off

REM Set variables
set gituser=dogi
set repo=ole--vagrant-vi
set port=5985

color 0b
echo This script will install BeLL-Apps on your computer
REM Get Admin For Batch File
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
  echo Requesting administrative privileges...
  echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
  set params = %*:"=""
  echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
  "%temp%\getadmin.vbs"
  del "%temp%\getadmin.vbs"
  exit
)
pushd "%CD%"
CD /D "%~dp0"



REM  Check for Virtualization and Install programs if enabled
powershell -ExecutionPolicy bypass -Command "& {$a = (Get-CimInstance -ClassName win32_processor -Property Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions); $a | Format-List Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions; $slat = $a.SecondLevelAddressTranslationExtensions; $virtual = $a.VirtualizationFirmwareEnabled; $vmextensions = $a.VMMonitorModeExtensions;If ($slat -eq $false){Write-Host 'BeLL-Apps is not compatible with your system. In order to install it, you need to upgrade your CPU first.';exit 5}Else{If ($virtual -eq $false){Write-Host 'Virtualization is not enabled. In order to install BeLL-Apps, you must enable it. Helpful link: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/';exit 5}} $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online;if ($hyperv.State -eq 'Enabled') {Write-Host 'Hyper-V is enabled on your computer. BeLL App cannot run with Hyper-V enabled.';Write-Host 'Disabling Hyper-V...';bcdedit /set hypervisorlaunchtype off;Write-Host 'Hyper-V has been disabled. Please`, reboot your computer`, then install BeLL App again.'pause;exit} Write-Host 'Please wait while BeLL-Apps is being installed...'; (iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1;RefreshEnv;choco install bonjour, git, vagrant, virtualbox, firefox -y -allowEmptyChecksums;RefreshEnv};"
if "%errorlevel%" equ "5" (
	pause
	exit
)

cd /D "C:\Users\%USERNAME%"
"\Program Files\Git\cmd\git.exe" clone https://github.com/%gituser%/%repo%.git
cd %repo%/windows
 
start start_vagrant_on_boot.bat 

REM Create desktop icon
set SCRIPT="%TEMP%\ole-helper.vbs"
echo set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo set oLink = oWS.CreateShortcut("C:\Users\%USERNAME%\Desktop\MyBeLL.lnk") >> %SCRIPT%
if exist "%PROGRAMFILES(x86)%\Mozilla Firefox\" (
	echo oLink.TargetPath = "%PROGRAMFILES(x86)%\Mozilla Firefox\firefox.exe" >> %SCRIPT%
) else (
	echo oLink.TargetPath = "%PROGRAMFILES%\Mozilla Firefox\firefox.exe" >> %SCRIPT%
)
echo oLink.IconLocation = "C:\Users\%USERNAME%\%repo%\windows\bell_logo.ico" >> %SCRIPT%
echo oLink.Arguments = "http://127.0.0.1:%port%/apps/_design/bell/MyApp/index.html" >> %SCRIPT%
echo oLink.Description = "My BeLL App"
echo oLink.Save >> %SCRIPT%
cscript %SCRIPT%
del %SCRIPT%

REM Open Windows Firewall Ports
netsh advfirewall firewall show rule name="CouchDB/HTTP(BeLL)+1" >nul
if not ERRORLEVEL 1 (
	echo Ports are already open.
	netsh advfirewall firewall delete rule name="CouchDB/HTTP(BeLL)+1" 
) 
echo Creating firewall rule CouchDB/HTTP(BeLL)+1
netsh advfirewall firewall add rule name="CouchDB/HTTP(BeLL)+1" dir=out action=allow protocol=TCP localport=%port%
netsh advfirewall firewall add rule name="CouchDB/HTTP(BeLL)+1" dir=in action=allow protocol=TCP localport=%port%

echo Installation completed. Vagrant is starting...
pause
exit
