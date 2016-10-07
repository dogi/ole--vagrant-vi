# please make this better (2 README.md to 1 new)

```
newer
```


# Install

To install a BeLL-Apps community on your system (x86 or amd64 architecture) just follow the instruction of your Operating System:

## Windows

```
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/dogi/ole--vagrant-community/master/windows/install.bat', 'install.bat')" && start install.bat && exit
```
```
@powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/dogi/ole--vagrant-community/master/windows/install.ps1', 'install.ps1')" && @powershell -NoProfile -ExecutionPolicy Bypass -Command ".\install.ps1"
```
Paste one of the above lines at a [Command prompt](http://www.howtogeek.com/235101/10-ways-to-open-the-command-prompt-in-windows-10/).

## MacOSX

```
/usr/bin/bash -e "$(curl -fsSL https://raw.githubusercontent.com/dogi/ole--vagrant-community/master/macosx/install.sh)"
```
Paste that at a [Terminal prompt](http://blog.teamtreehouse.com/introduction-to-the-mac-os-x-command-line).

## Ubuntu

```
/usr/bin/bash -e "$(curl -fsSL https://raw.githubusercontent.com/dogi/ole--vagrant-community/master/ubuntu/install.sh)"
```
Paste that at a [Terminal prompt](http://askubuntu.com/questions/183775/how-do-i-open-a-terminal).

```
older
```
# ole--vagrant-community

ole--vagrant-community gives users the ability to install fast their own community [BeLL](https://github.com/open-learning-exchange/BeLL-Apps) (Basic e-Learning Library) on their computer. 

## Requirements
- Install [git](https://git-scm.com/downloads)
  - [Git](https://git-scm.com) is an open source version control system that we use for communication and management for our software. More specifically, we use gitter.im for communication and github.com for software management.
  - Confirmed working on v2.5.0 (check with `git --version`)
- Install [virtualbox](https://www.virtualbox.org/wiki/Downloads)
  - [Virtualbox](https://www.virtualbox.org) allows you to install a software virtualization package as an application on your OS. 
  - Confirmed working on v5.0.14 (check with `vboxmanage --version`)
- Install [vagrant](https://www.vagrantup.com/downloads.html)
  - [Vagrant](https://www.vagrantup.com) is an open source tool for building development environments. 
  - Confirmed working on v1.8.1 (check with `vagrant --version`)
- (Optional for Windows Users) [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
  - [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/) is free implementation of SSH and Telnet for Windows and Unix platforms, along with an xterm terminal emulator.
 
### Ubuntu
```sh
    sudo apt-get install git
    sudo apt-get install virtualbox
    sudo apt-get install vagrant
```

### OSX
Open your `Terminal`. We assume that [brew](http://brew.sh/) is already installed.
```sh
    brew install git 
    brew cask install vagrant
    brew cask install virtualbox
```

### Windows
You need to manually install git, virtualbox, and vagrant via internet from the installation links provided above. Afterwards, open your `Command Prompt` to check that the following are up and running properly:
```sh
git --version
vagrant --version
vboxmanage --version  
```

## Install a communityBeLL on your OS
In your `Terminal` or `Command Prompt`, type:
```sh
git clone https://github.com/dogi/ole--vagrant-community.git
cd ole--vagrant-community
vagrant up
```

You now have a working [communityBeLL](http://127.0.0.1:5984/apps/_design/bell/MyApp/index.html) on your OS.
