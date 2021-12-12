# raspberry-pi-scripts
Raspberry pi related

= Magic Mirror setup on a Raspberri pi zero w =<br>
Inspiration: http://emmanuelcontreras.com/how-to/how-to-create-a-magic-mirror-2-with-pi-zero-w/<br>

Equipment
- Raspberri pi zero w
- 16 G micro sd card
- Hdmi cable
- Hdmi Monitor or tv

Setup 
- Install Rasbian Full Version with Raspberri Pi Imager<br>
https://downloads.raspberrypi.org/imager/imager_latest.dmg

- Format sd card and install the full Raspbian OS 

- Raspberry configuration: sudo raspi-config<br>
+Interfacing Options / Enable SSH<br>
+AutoLogin to raspberry pi<br>
   Boot Options -> B1 Desktop/CLI -> B2 Console Autologin // we want to get the console<br>

- Setting up WiFi<br>
sudo vi /etc/wpa_supplicant/wpa_supplicant.config<br>
network={<br>
ssid=”Your_wifi_name”<br>
psk=“Your_wifi_password”<br>
}<br>

- Create the folders for the source code<br>
mkdir -p /Development/source<br>
export HOME="/Development/source"<br>

- Install git<br>
sudo apt install git<br>

- Install node v16.2.0<br>
wget https://unofficial-builds.nodejs.org/download/release/v16.2.0/node-v16.2.0-linux-armv61.tar.gz .<br>
tar xvf above file<br>
cd above file<br>
cp -R * /usr/local<br>

- Install npm 8.2.0<br>
sudo apt install npm<br> 
npm install -g npm@8.2.0 // if it isn't the right version<br>

- Install midori browser // chromium-browser would not work on armv6l<br>
sudo apt install midori<br>
https://manpages.debian.org/stretch/midori/midori.1<br>

- Install MagicMirror<br>
cd $HOME<br>
git clone https://github.com/MichMich/MagicMirror<br>
npm install -arch=armv7l<br>

- AutoLogin to raspberry pi<br>
sudo raspi-config<br>
 Boot Options -> B1 Desktop/CLI -> B2 Console Autologin<br>

- Install xinit (program that allows you to start “x” server)<br>
sudo apt-get install xinit<br>

- Install Xorg (display server)<br>
sudo apt install xorg<br>

- Install matchbox (window manager)<br>
sudo apt install matchbox<br>

- Get rid of cursor with Unclutter<br>
sudo apt install unclutter<br>

- Make two script files in $HOME<br>
1. mm_start.sh <br>
#!/bin/bash<br>
cd /Development/source/MagicMirror<br>
node serveronly &<br>
sleep 30<br>
xinit /home/pi/midori_start.sh<br>

2. midori_start.sh<br>
#!/bin/sh<br>
#unclutter &<br>
xset -dpms # disable DPMS (Energy Star) features.<br>
xset s off # disable screen saver<br>
xset s noblank # don’t blank the video device<br>
matchbox-window-manager &<br>
midori -a http://localhost:8080 -e Fullscreen<br>
while :<br>
do  <br>
    sleep 120;<br>
    echo "Reload midori"<br>
    midori -e Reload<br>
done <br>

- Make both files executable<br>
$ sudo chmod a+x mm_start.sh<br>
$ sudo chmod a+x midori_start.sh<br>

- Auto Starting MagicMirror (I followed the guide on the MM github page)<br> 
<br>
Before doing this, make sure any user can launch an Xorg process(IhadtodothisSinceISSHintoThePi)<br>
Change the value of “allowed_users=console” to “allowed_users=anybody” in /etc/X11/Xwrapper.config.<br>
Create the file and add key value pair inside. <br>

- Install pm2 and start it<br>
$ sudo npm install -g pm2<br>
$ pm2 startup<br>

- Copy and paste the command that the screen prints out, otherwise the pm2 process won’t save<br>
Note: Latest version of pm2 didn’t provide this link below but you need to run it or pm2 will not save or start automatically on reboot<br>
$ sudo env PATH=$PATH:/usr/local/bin /usr/local/lib/node_modules/pm2/bin/pm2 startup systemd -u pi –hp /home/pi<br>
$ sudo pm2 start mm_start.sh<br>
magic mirror should start running in chromium<br>
$ sudo pm2 save<br>

if node doesn't want to start in package.json replace start command with...<br>
"start": "node_modules/.bin/electron js/electron.js",<br>

Upon reboot, wait 5 minutes before it loads.. 

--- 
PM2 commands<br>
sudo pm2 restart mm_start<br>
