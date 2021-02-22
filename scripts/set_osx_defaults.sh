#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"
. "$DIR/ansi"

if [[ "$OSTYPE" != "darwin"* ]]; then
	ansi --green "Not a darwin platform. Skipping."
	exit 0
fi

# mostly from: https://github.com/mathiasbynens/dotfiles/blob/main/.macos

ansi --green "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

ansi --green "Save to disk and not in iCloud by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

ansi --green "Quit printer app when jobs are completed"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

ansi --green "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

ansi --green "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

ansi --green "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

ansi --green "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

ansi --green "Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

ansi --green "Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

ansi --green "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

ansi --green "Finder: show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true

ansi --green "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

ansi --green "Avoid creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

ansi --green "Set to check daily instead of weekly"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

ansi --green "Set default clock format"
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM h:mm:ss a"

ansi --green "Set Default Finder Location to Home Folder"
defaults write com.apple.finder NewWindowTarget -string "PfLo" &&
	defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

ansi --green "Killing Finder.."
killall Finder

ansi --green "Killing SystemUIServer"
killall SystemUIServer

if [ "${CI:-0}" = "1" ]; then
	ansi --green "Skipping sudo required commands"
	exit 0
fi

# ask sudo upfront
sudo -v

ansi --green "Build Locate Database"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

ansi --green "Enable firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

ansi --green "Set Clock Using Network Time"
sudo systemsetup setusingnetworktime on

ansi --green "Killing SystemUIServer"
killall SystemUIServer
