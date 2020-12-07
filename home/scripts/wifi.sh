#/bin/sh

systemctl start dhcpcd@wls3.service
sudo ip link set wls3 up
sudo wpa_supplicant -B -i wls3 -c '/etc/wpa_supplicant/wpa_supplicant.conf'
