
Write-Host This script will install your BeLL App. -ForegroundColor Magenta

Write-Host Asking for admin privileges. Please`, accept any prompt that may pop up. -ForegroundColor Magenta

Sleep 5

# Take admin privileges
if (! ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
          [Security.Principal.WindowsBuiltInRole] "Administrator")) {   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments
	Break
}

Write-Host Please`, wait while we check if your computer is compatible with BeLL App... -ForegroundColor Magenta

# Set ExecutionPolicy to Bypass
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

#Check for Virtualization
$a = (Get-CimInstance -ClassName win32_processor -Property Name, 
                      SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions)
$a | Format-List Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions
$slat = $a.SecondLevelAddressTranslationExtensions
$virtual = $a.VirtualizationFirmwareEnabled
$vmextensions = $a.VMMonitorModeExtensions
if ($slat -eq $false) {
    Write-Host BeLL-Apps is not compatible with your system. In order to install it, you need to upgrade your CPU first. -ForegroundColor Magenta
    pause
    exit
} else {
	if ($virtual -eq $false) {
        Write-Host Virtualization is not enabled. In order to install BeLL-Apps, you must enable it. `
        Helpful link: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/ -ForegroundColor Magenta
        pause
        exit
	}
}

# Check if Hyper-V is enabled
$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
if ($hyperv.State -eq "Enabled") {
    Write-Host Hyper-V is enabled on your computer. BeLL App cannot run with Hyper-V enabled. -ForegroundColor Magenta
    Write-Host Disabling Hyper-V... -ForegroundColor Magenta
    bcdedit /set hypervisorlaunchtype off
    Write-Host Hyper-V has been disabled. Please`, reboot your computer`, then install BeLL App again. -ForegroundColor Magenta
    pause
    exit 
}

Write-Host Your computer is compatible! -ForegroundColor Magenta
Write-Host Please`, wait while the necessary programs are being installed... -ForegroundColor Magenta
Write-Host "NOTE: Please, pay attention only to the messages written in this color `(magenta`). 
      You can safely disregard ALL other messages." -ForegroundColor Magenta

# Install Chocolatey
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1
# Add Chocolatey to the Path
RefreshEnv

# Install the other required programs
choco install bonjour, git, virtualbox, vagrant, firefox -y -allowEmptyChecksums
# Add programs to the Path
RefreshEnv

#### Paranoid Check ####
# Check if bonjour, git, virtualbox, vagrant, firefox have actually been installed
$progs = New-Object System.Collections.ArrayList
$prog = ""
if (! (Test-Path "C:\Program File*\*\firefox.exe")) {
    $progs.Add("Firefox")
}
if (! (Test-Path "C:\HashiCorp\*\*\vagrant.exe")) {
    $progs.Add("Vagrant")
}
if (! (Test-Path "C:\Program File*\*\*\virtualbox.exe")) {
    $progs.Add("Virtualbox")
}
if (! (Test-Path "C:\Program File*\*\*\git.exe")) {
    $progs.Add("Git")
}
if (! (Test-Path "C:\Program File*\*\mDNSResponder.exe")) {
    $progs.Add("Bonjour")
}

# Add word separator for printing
$progs | % {$prog += ($(if($prog){" and "}) + $_)}
if ($progs.Count -eq 1) {$verb, $pron = "is", "it"}
else {$verb, $pron = "are", "them"}

# If any of the programs was not installed, ask the user to install them manually before continuing
if ($progs.Count -gt 0) {
    Write-Host "                ================================================================================================`
               | Unfortunately`, $prog could not be installed.`
               | Please`, BEFORE pressing Enter to continue, 
               | make sure that $prog $verb installed (install $pron manually, if necessary). 
                ================================================================================================" -ForegroundColor Magenta
    pause
}
#### End Paranoid Check ####

Write-Host All necessary programs have been installed. -ForegroundColor Magenta
Write-Host Please, wait while the BeLL community is being installed... -ForegroundColor Magenta

# Git clone OLE Vagrant Community
# Write-Host "Please, enter your GitHub username, or press Enter to continue:" -ForegroundColor Magenta
# $gituser = Read-Host
# if ($gituser -eq "") {$gituser = "dogi"}
$gituser = "dogi" # comment out this line when uncommenting the three lines above
cd $HOME
& 'C:\Program Files\Git\bin\git.exe' clone https://github.com/$gituser/ole--vagrant-vi.git
cd .\ole--vagrant-vi

# Delete unneeded files
Remove-Item C:\$HOME\ole--vagrant-vi\windows\* -include .bat

# Open ports on network
New-NetFirewallRule -DisplayName "Allow Outbound Port 5984 CouchDB/HTTP" -Direction Outbound –LocalPort 5984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Inbound Port 5984 CouchDB/HTTP" -Direction Inbound –LocalPort 5984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Outbound Port 6984 CouchDB/HTTPS" -Direction Outbound –LocalPort 6984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Inbound Port 6984 CouchDB/HTTPS" -Direction Inbound –LocalPort 6984 -Protocol TCP -Action Allow

# Start Vagrant at Startup
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
Register-ScheduledJob -Trigger $trigger -FilePath $HOME\ole--vagrant-vi\windows\vagrantup.ps1 -Name VagrantUp

# Create a desktop icon
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("$HOME\Desktop\MyBeLL.lnk")
if (Test-Path 'C:\Program Files (x86)\Mozilla Firefox') {
    $Shortcut.TargetPath = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
} else {
    $Shortcut.TargetPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
}
$Shortcut.IconLocation = "$HOME\ole--vagrant-vi\windows\bell_logo.ico, 0"
$Shortcut.Arguments = "http://127.0.0.1:5985/apps/_design/bell/MyApp/index.html"
$Shortcut.Description = "My BeLL App"
$Shortcut.Save()

Write-Host The BeLL community has been installed. -ForegroundColor Magenta
Write-Host Now, we will install the virtual machine, and then you`'ll be all set. -ForegroundColor Magenta

# Start the VM
& ((Split-Path $MyInvocation.MyCommand.Path) + "\vagrantup.ps1")
