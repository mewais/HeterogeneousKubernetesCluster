#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "The script needs two arguments, the hosts file, and the target devices file"
	echo "For example: ./gen_devices.sh ../../hosts devices.yaml"
    exit 2
fi

IPs=( $(cat $1 | grep storage | cut -d' ' -f1) )

echo -e "        nodes:" > $2
for (( i=0; i<${#IPs[@]}; i++ ));
do
	echo -e "            - name: \"${IPs[$i]}\"" >> $2
	echo -e "              devices:" >> $2
	echo -e "                - name: \"/dev/sdb\"" >> $2
done
