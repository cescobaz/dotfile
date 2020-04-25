## Networw

### Show current state
ip address show

### Shutdown/up interface
ip link set _interface_ down

### Scan wireless
As root run wpa_cli then _scan_ and *scan_results*
By wpa_cli it is also possible to connect to a wireless

### Connecte to wireless with password
sudo wpa_supplicant -B -i wlan0 -c <(wpa_passphrase _SSID_ _passphrase_)


### Set profile (available in /etc/netctl/) for boot
netctl enable _profile_


