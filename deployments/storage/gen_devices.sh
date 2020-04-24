#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "The script needs two arguments, the hosts file, and the target devices file"
	echo "For example: ./gen_devices.sh ../../hosts devices.yaml"
    exit 2
fi

IPs=( $(cat $1 | grep storage | cut -d' ' -f1) )
hostnames=( $(cat $1 | grep storage | cut -d' ' -f2) )

echo -e "        nodes:" > $2
for (( i=0; i<${#hostnames[@]}; i++ ));
do
	echo -e "            - name: \"${hostnames[$i]}\"" >> $2
	echo -e "              devices:" >> $2
	echo -e "                - name: \"sdb\"" >> $2
done
