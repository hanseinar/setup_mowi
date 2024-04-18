#!/bin/bash

# Update the system
sudo apt update && sudo apt upgrade -y

# Check for xdotool and install if missing
if ! command -v xdotool &> /dev/null
then
    echo "xdotool could not be found, installing..."
    sudo apt install xdotool -y
fi

# Disable power management
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-ac -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-battery -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-ac -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-battery -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s false

# Disable screensaver
xfconf-query -c xfce4-session -p /startup/screensaver/enabled -n -t bool -s false

# Download and set the desktop background
wget -O /usr/share/backgrounds/mowi_logo.png https://upload.wikimedia.org/wikipedia/commons/6/69/MOWI_logo.png
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s /usr/share/backgrounds/mowi_logo.png
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-style -n -t int -s 0  # 0 is for "centered"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/last-image -s /usr/share/backgrounds/mowi_logo.png
# Set background color
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/backdrop-cycle-enable -n -t bool -s false
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/color-style -n -t int -s 0  # Solid color
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/rgba1 -n -t uint -s 42
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/rgba2 -n -t uint -s 49
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/rgba3 -n -t uint -s 55
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/rgba4 -n -t uint -s 255

# Open and close Thunar to ensure its configuration files are initialized
thunar &
sleep 2
killall Thunar

# Set Thunar to List View by default
xfconf-query -c thunar -p /last-view -s "ThunarDetailsView"

# Add bookmark to Firefox and launch in fullscreen
echo 'user_pref("browser.startup.homepage", "https://grafana-mowi.cogniteapp.com/dashboards");' >> ~/.mozilla/firefox/*.default/prefs.js
echo 'user_pref("browser.toolbars.bookmarks.2h2020", true);' >> ~/.mozilla/firefox/*.default/prefs.js
firefox https://grafana-mowi.cogniteapp.com/dashboards & sleep 5 && xdotool key F11
