#!/bin/bash

#assuming brew cask is installed (via install script);
VB="virtualbox";
VG="vagrant";
cask_list=`brew cask list`;

vb=$(echo "$cask_list" | grep "$VB" );
vg=$(echo "$cask_list" | grep "$VG" );

#the variables vb and vg contain the value "virtualbox" and "vagrant" respectively if they are installed
if [[ $vb == "$VB" ]] ; then
echo "unistalling virtual box";
brew cask uninstall virtualbox;
else
echo 'virtualbox not installed'
fi

if [[ $vg == "$VG" ]] ; then
echo "unistalling vagrant";
brew cask uninstall vagrant;
else
echo 'vagrant not installed'
fi

#remove com.ole.virtualboot.plist
rm /Users/${USER}/Library/LaunchAgents/com.ole.virtualboxboot.plist

echo "Finish uninstall"