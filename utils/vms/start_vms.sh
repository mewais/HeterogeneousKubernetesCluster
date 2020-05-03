#!/bin/bash

echo "Starting Masters"
vboxmanage startvm master-01 --type headless
vboxmanage startvm master-02 --type headless
vboxmanage startvm master-03 --type headless

echo "Starting Storage Workers"
vboxmanage startvm storage-worker-01 --type headless
vboxmanage startvm storage-worker-02 --type headless
vboxmanage startvm storage-worker-03 --type headless

echo "Starting Workers"
vboxmanage startvm worker-01 --type headless
vboxmanage startvm worker-02 --type headless
vboxmanage startvm worker-03 --type headless
vboxmanage startvm worker-04 --type headless
