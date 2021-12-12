# raspberry-pi-scripts
Raspberry pi related

= Magic Mirror setup on a Raspberri pi zero = 
Inspiration
http://emmanuelcontreras.com/how-to/how-to-create-a-magic-mirror-2-with-pi-zero-w/

Equipment
- Raspberri pi zero w
- 16 G micro sd card
- Hdmi cable
- Hdmi Monitor or tv

Setup 
- Install Rasbian Full Version with Raspberri Pi Imager
https://downloads.raspberrypi.org/imager/imager_latest.dmg

- Format sd card and install the full Raspbian OS 

- Raspberry configuration: sudo raspi-config
+Interfacing Options / Enable SSH
+AutoLogin to raspberry pi
   Boot Options -> B1 Desktop/CLI -> B2 Console Autologin // we want to get the console

- Setting up WiFi
sudo vi /etc/wpa_supplicant/wpa_supplicant.config
network={
ssid=”Your_wifi_name”
psk=“Your_wifi_password”
}

Create the folders for the source code
mkdir -p /Development/source 
export HOME="/Development/source"

Install git
sudo apt install git

Install node v16.2.0
wget https://unofficial-builds.nodejs.org/download/release/v16.2.0/node-v16.2.0-linux-armv61.tar.gz .
tar xvf above file
cd above file
cp -R * /usr/local

Install npm 8.2.0
sudo apt install npm 
npm install -g npm@8.2.0 // if it isn't the right version

Install midori browser // chromium-browser would not work on armv6l
sudo apt install midori
https://manpages.debian.org/stretch/midori/midori.1

Install MagicMirror
cd $HOME
git clone https://github.com/MichMich/MagicMirror
npm install -arch=armv7l

AutoLogin to raspberry pi
sudo raspi-config
 Boot Options -> B1 Desktop/CLI -> B2 Console Autologin
Install xinit (program that allows you to start “x” server)

sudo apt-get install xinit

Install Xorg (display server)
sudo apt install xorg

Install matchbox (window manager)
sudo apt install matchbox

Get rid of cursor with Unclutter
sudo apt install unclutter

Make two script files in $HOME
1. mm_start.sh 
#!/bin/bash
cd /Development/source/MagicMirror
node serveronly &
sleep 30
xinit /home/pi/midori_start.sh

2. midori_start.sh
#!/bin/sh
#unclutter &
xset -dpms # disable DPMS (Energy Star) features.
xset s off # disable screen saver
xset s noblank # don’t blank the video device
matchbox-window-manager &
midori -a http://localhost:8080 -e Fullscreen
while :
do  
    sleep 120;
    echo "Reload midori"
    midori -e Reload
done 

Make both files executable
$ sudo chmod a+x mm_start.sh
$ sudo chmod a+x midori_start.sh

Auto Starting MagicMirror (I followed the guide on the MM github page) 

Before doing this, make sure any user can launch an Xorg process(IhadtodothisSinceISSHintoThePi)
Change the value of “allowed_users=console” to “allowed_users=anybody” in /etc/X11/Xwrapper.config.
Create the file and add key value pair inside. 

Install pm2 and start it
$ sudo npm install -g pm2
$ pm2 startup

Copy and paste the command that the screen prints out, otherwise the pm2 process won’t save
Note: Latest version of pm2 didn’t provide this link below but you need to run it or pm2 will not save or start automatically on reboot
$ sudo env PATH=$PATH:/usr/local/bin /usr/local/lib/node_modules/pm2/bin/pm2 startup systemd -u pi –hp /home/pi
$ sudo pm2 start mm_start.sh
magic mirror should start running in chromium
$ sudo pm2 save

if node doesn't want to start in package.json replace start command with...
"start": "node_modules/.bin/electron js/electron.js",

--- 
PM2 commands
sudo pm2 restart mm_start
