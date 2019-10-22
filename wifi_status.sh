#!/bin/bash 

#nmcli -t -f active,ssid dev wifi | grep yes
#active_con=$(nmcli -g name con show --active)
TYP="802-11-wireless"
active_con=$(nmcli -g name,type con show --active | grep $TYP | awk -F ':' '{ print $1 }')
if [ "A$active_con" = "A" ] ; then
  echo ""
  exit 0
else
  ip4=$(nmcli -g ip4 con show $active_con | awk -F ':' '{ print $2}')
  echo "$active_con:$ip4"
fi
