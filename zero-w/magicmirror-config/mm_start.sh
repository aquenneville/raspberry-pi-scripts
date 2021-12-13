#!/bin/bash
cd /Development/source/MagicMirror
node serveronly &
sleep 30
xinit /home/pi/midori_start.sh
