@echo off

REM Set variables
set repo=ole--vagrant-vi
set port=5985

color 0b
echo This script will uninstall BeLL-Apps from your computer 
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
powershell -ExecutionPolicy bypass -Command "& {Write-Host 'Uninstalling Bonjour...'; choco uninstall bonjour -y; $vm = Read-Host 'Do you want to remove the virtual machine? (Y)es, (N)o'; if ($vm.ToUpper() -eq 'Y' -or $vm -eq '') {C:\HashiCorp\Vagrant\bin\vagrant.exe destroy community -f}$box = Read-Host 'Do you want to remove also all the files? (Y)es, (N)o'; if ($box.ToUpper() -eq 'Y' -or $box -eq '') {C:\HashiCorp\Vagrant\bin\vagrant.exe box remove ole/jessie64 -f} choco uninstall vagrant -y; $vb = Read-Host 'Are you sure you want to remove Virtualbox? (Y)es, (N)o'; if ($vb.ToUpper() -eq 'Y' -or $vb -eq '') {choco uninstall virtualbox -y} $git = Read-Host 'Are you sure you want to remove Git? (Y)es, (N)o'; if ($git.ToUpper() -eq 'Y' -or $git -eq '') {choco uninstall git, git.install -y; Remove-Item $env:ALLUSERSPROFILE\git -Force -Recurse} $ff = Read-Host 'Are you sure you want to remove Firefox? (Y)es, (N)o'; if ($ff.ToUpper() -eq 'Y' -or $ff -eq '') {choco uninstall firefox -y} Remove-Item C:\Users\*\Desktop\MyBeLL.lnk -Force; $ch = Read-Host 'Are you sure you want to uninstall Chocolatey? (Y)es, (N)o'; if ($ch.ToUpper() -eq 'Y' -or $ch -eq '') {choco uninstall chocolatey -y;exit 5}}"
if "%errorlevel%" equ "5"  (
	RD /S /Q "%ALLUSERSPROFILE%\chocolatey"
)



netsh advfirewall firewall show rule name="CouchDB/HTTP(BeLL)+1" >nul
if not ERRORLEVEL 1 (
	echo Blocking Port %port%...
	netsh advfirewall firewall delete rule name="CouchDB/HTTP(BeLL)+1" 
)

IF EXIST "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start_vagrant_on_boot.bat" (
	del "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start_vagrant_on_boot.bat"
)

echo Uninstallation completed.
pause
echo Deleting %repo% folder..
RD /S /Q "C:\Users\%USERNAME%\%repo%"
exit

