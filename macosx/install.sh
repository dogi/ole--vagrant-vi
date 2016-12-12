#!/bin/bash

#check if `brew` is installed
MAN_BREW=`man brew`
if [ "$MAN_BREW" = "" ]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
#if not install git, vagrant, virtualbox
CHECK_GIT=`brew list | grep git`
if[ "$CHECK_GIT" == "" ]
	brew install git

CHECK_VARGANT=`brew cask list | grep vagrant`
if[ "$CHECK_VARGANT" == "" ]	
	brew cask install vagrant

CHECK_VIRTUALBOX=`brew cask list | grep virtualbox`
if[ "$CHECK_VIRTUALBOX" == "" ]
	brew cask install virtualbox

#install bell app
cd ~
git clone https://github.com/dogi/ole--vagrant-vi.git
cd ole--vagrant-community
vagrant up

#start virtual machine when user log in
mv ~/ole--vagrant-community/macosx/com.ole.virtualboxboot.plist /Users/${USER}/Library/LaunchAgents/

#place Icon into Dock
mv ~/ole--vagrant-community/macosx/BellCommunity.app /Applications/
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/BellCommunity.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

# Reset Dock
killall Dock

