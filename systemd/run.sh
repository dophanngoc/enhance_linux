#!/usr/bin/bash

ifname_used=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | sed -n '1p;1q' | cut -d ' ' -f 2)
if [ ! -f /usr/bin/mac_changer.sh ]; then
   sudo tee -a /usr/bin/mac_changer.sh > /dev/null << EOT
#!/usr/bin/bash
sudo ip link set $ifname_used down
sudo macchanger -r $ifname_used
sudo ip link set $ifname_used up
EOT
   echo -e "wrote to /usr/bin/mac_changer.sh\n"
   sudo chmod +x /usr/bin/mac_changer.sh
fi
if [ ! -f /etc/systemd/system/mac_changer.service ]; then
   sudo echo -e "writting to /etc/systemd/system/mac_changer.service\n"
   sudo tee -a /etc/systemd/system/mac_changer.service > /dev/null << EOT
[Unit]
Description=changes mac for $ifname_used 
Wants=network.target
Before=network.target
#BindsTo=sys-subsystem-net-devices-$ifname_used.device
#After=sys-subsystem-net-devices-$ifname_used.device

[Service]
Type=oneshot
ExecStart=/usr/bin/mac_changer.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOT

   sudo systemctl start mac_changer.service
   sudo systemctl enable mac_changer.service
fi
