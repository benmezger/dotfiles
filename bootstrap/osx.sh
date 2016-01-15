sudo -v # prompt user for password upfront

# play chime sound when macbook power connects
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true; 
open /System/Library/CoreServices/PowerChime.app &
