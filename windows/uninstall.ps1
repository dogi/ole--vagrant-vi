# Set variable
$repo = ole--vagrant-vi
$port = 5985

Write-Host This script will uninstall BeLL App from your computer. -ForegroundColor Magenta

Write-Host Asking for admin privileges. Please`, accept any prompt that may pop up. -ForegroundColor Magenta

Sleep 5

# Run as Admin
if (! ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
       [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# Ask user what programs to uninstall
Write-Host Please, answer the following questions before we start to uninstall the BeLL. -ForegroundColor Magenta
Write-Host "Would you like to remove the virtual machine? (Y)es, (N)o" -ForegroundColor Magenta
$vm = Read-Host
Write-Host "Would you like also to remove all the files? (Y)es, (N)o" -ForegroundColor Magenta
$box = Read-Host
Write-Host "Would you like to uninstall Virtualbox? (Y)es, (N)o" -ForegroundColor Magenta
$vb = Read-Host
Write-Host "Would you like to uninstall Git? (Y)es, (N)o" -ForegroundColor Magenta
$git = Read-Host
Write-Host "Would you like to uninstall Firefox? (Y)es, (N)o" -ForegroundColor Magenta
$ff = Read-Host
Write-Host "Would you like to uninstall Chocolatey? (Y)es, (N)o" -ForegroundColor Magenta
$ch = Read-Host
Write-Host "Would you like to enable Hyper-V? NOTE: If you don't know what Hyper-V is, it is safer to leave it disabled. (Y)es, (N)o" -ForegroundColor Magenta
$hv = Read-Host

# Uninstall Bonjour
Write-Host Uninstalling Bonjour... -ForegroundColor Magenta
choco uninstall bonjour -y


# Remove OLE community VM and box, only if the user agrees
if ($vm.ToUpper() -eq 'Y' -or $vm -eq "") {
    Write-Host Removing the virtual machine... -ForegroundColor Magenta
    C:\HashiCorp\Vagrant\bin\vagrant.exe destroy community -f
}

if ($box.ToUpper() -eq 'Y' -or $box -eq "") {
    Write-Host Removing all the files... -ForegroundColor Magenta
    C:\HashiCorp\Vagrant\bin\vagrant.exe box remove ole/jessie64 -f
}

# Uninstall vagrant
Write-Host Uninstalling Vagrant... -ForegroundColor Magenta
choco uninstall vagrant -y

# Only uninstall Virtualbox if the user agrees
if ($vb.ToUpper() -eq 'Y' -or $vb -eq "") {
    Write-Host Uninstalling Virtualbox... -ForegroundColor Magenta
    choco uninstall virtualbox -y
}

# Only uninstall Git if the user agrees
if ($git.ToUpper() -eq 'Y' -or $git -eq "") {
    Write-Host Unintalling Git... -ForegroundColor Magenta
    choco uninstall git, git.install -y
}

# Only uninstall Firefox if the user agrees
if ($ff.ToUpper() -eq 'Y' -or $ff -eq "") {
    Write-Host Uninstalling Firefox... -ForegroundColor Magenta
    choco uninstall firefox -y
}

# Only uninstall chocolatey if the user agrees
if ($ch.ToUpper() -eq 'Y' -or $ch -eq "") {
    Write-Host Uninstalling Chocolatey... -ForegroundColor Magenta
    choco uninstall chocolatey -y
    Get-ChildItem -Path "$env:ALLUSERSPROFILE\chocolatey" -Recurse | Remove-Item -Force -Recurse
    Remove-Item "$env:ALLUSERSPROFILE\chocolatey" -Force -Recurse
}

# Reactivate Hyper-V, if the user agrees
if ($hv.ToUpper() -eq 'Y' -or $hv -eq "") {
    bcdedit /set hypervisorlaunchtype auto
    Write-Host Hyper-V is now enabled. -ForegroundColor Magenta
}

# Remove ole--vagrant-vi folder and subfolders
Write-Host Removing BeLL App... -ForegroundColor Magenta
Get-ChildItem -Path "$HOME\$repo" -Recurse | Remove-Item -Force -Recurse
Remove-Item "$HOME\$repo" -Force -Recurse

# Remove firewall rule
Remove-NetFirewallRule -DisplayName "Allow Outbound Port $port CouchDB/HTTP"
Remove-NetFirewallRule -DisplayName "Allow Inbound Port $port CouchDB/HTTP"

# Remove vagrant job from Startup
Unregister-ScheduledJob VagrantUp -Force

# Remove desktop icon
Remove-Item C:\Users\*\Desktop\MyBeLL.lnk -Force

Write-Host All done! Your BeLL App has been removed. -ForegroundColor Magenta
Write-Host You can now close this window. -ForegroundColor Magenta
