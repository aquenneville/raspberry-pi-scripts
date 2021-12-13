#!/bin/sh
#unclutter &
xset -dpms # disable DPMS (Energy Star) features.
xset s off # disable screen saver
xset s noblank # don’t blank the video device
matchbox-window-manager &
#chromium-browser --incognito --kiosk http://localhost:8080/ #these are two single dashes before incognito and kiosk
#midori -a http://localhost:8080 -i 120 -e Fullscreen
midori -a http://localhost:8080 -e Fullscreen
while :
do  
    sleep 120;
    echo "Reload midori"
    midori -e Reload
done 
