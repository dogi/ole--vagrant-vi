# Set variable
$repo = "ole--vagrant-vi"

# Start the VM
Write-Host Starting BeLL App... -ForegroundColor Magenta
cd $HOME\$repo
C:\HashiCorp\Vagrant\bin\vagrant.exe up
$state = C:\HashiCorp\Vagrant\bin\vagrant.exe status --machine-readable | Select-String "state,running"
if ($state) {
    Write-Host You can now click on the MyBeLL icon on your desktop to launch your BeLL App. -ForegroundColor Magenta
} else {
    Write-Host Your BeLL App virtual machine doesn`'t seem to be running properly. -ForegroundColor Magenta
}