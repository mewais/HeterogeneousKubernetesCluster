#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "The script needs two arguments, the hosts file, and the target topology file"
	echo "For example: ./gen_storage_topology.sh ../hosts my_new_topology.json"
    exit 2
fi

hostnames=( $(cat $1 | grep storage | cut -d' ' -f2) )
IPs=( $(cat $1 | grep storage | cut -d' ' -f1) )

echo "{
  \"clusters\": [
    {
      \"nodes\": [" > $2

for (( i=0; i<${#hostnames[@]}; i++ ));
do
	echo "${hostnames[$i]}"
	echo "${IPs[$i]}"
	echo "        {
          \"node\": {
            \"hostnames\": {
              \"manage\": [
                \"${hostnames[$i]}\"
              ],
              \"storage\": [
                \"${IPs[$i]}\"
              ]
            },
            \"zone\": 1
          },
          \"devices\": [
            \"/dev/sdb\"
          ]
        }," >> $2
done

truncate -s-2 $2

echo "
      ]
    }
  ]
}" >> $2
