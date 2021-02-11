#!/bin/bash

#check if `brew` is installed
MAN_BREW=`man brew`
if [ "$MAN_BREW" = "" ]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#if not install git, vagrant, virtualbox
CHECK_GIT=`brew list | grep git`
if [ "$CHECK_GIT" = "" ]; then
	brew install git
fi

CHECK_VARGANT=`brew cask list | grep vagrant`
if [ "$CHECK_VARGANT" = "" ]; then	
	brew cask install vagrant
fi

CHECK_VIRTUALBOX=`brew cask list | grep virtualbox`
if [ "$CHECK_VIRTUALBOX" = "" ]; then
	brew cask install virtualbox
fi; then

#install bell app
cd ~
git clone https://github.com/dogi/ole--vagrant-vi.git
cd ole--vagrant-vi
vagrant up

#start virtual machine when user log in
mv ~/ole--vagrant-vi/macosx/com.ole.virtualboxboot.plist /Users/${USER}/Library/LaunchAgents/

#place Icon into Dock
mv ~/ole--vagrant-vi/macosx/BellCommunity.app /Applications/
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/BellCommunity.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

# Reset Dock
killall Dock
