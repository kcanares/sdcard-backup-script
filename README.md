Automatically backup your mass storage device like an sd card to your cloud provider using an rclone script. This runs automatically after plugging in your sd card. No more dragging and dropping

### prerequisites
- Linux machine
- You will need to setup rclone and configure a cloud connection on your machine
  
### installation
Update some of the constants in the files with your details like your user name. Then,
Run these commands in your terminal
```
# Script
sudo cp sdcard-backup.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/sdcard-backup.sh

# services
sudo cp sdcard-backup.service /etc/systemd/system/
sudo cp 99-sdcard-backup.rules /etc/udev/rules.d/

# Activation
sudo systemctl daemon-reload
```
