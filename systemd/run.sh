#!/usr/bin/env bash

ifname_list=$(ip -o link show | awk -F': ' '{print $2}' | sed '/lo/'d)
if [ ! -f /usr/bin/mac_changer.sh ]; then
   sudo tee -a /usr/bin/mac_changer.sh > /dev/null << EOT
#!/usr/bin/env bash

EOT
   while IFS= read -r line
   do
      sudo tee -a /usr/bin/mac_changer.sh > /dev/null << EOT
sudo ip link set $line down
sudo macchanger -r $line
sudo ip link set $line up
EOT
   done <<< $ifname_list
   echo -e "Wrote to /usr/bin/mac_changer.sh\n"
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
