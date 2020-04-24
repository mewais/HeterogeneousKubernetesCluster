#!/bin/bash

echo "Starting Masters"
vboxmanage controlvm master-01 savestate
vboxmanage controlvm master-02 savestate
vboxmanage controlvm master-03 savestate

echo "Starting Storage Workers"
vboxmanage controlvm storage-worker-01 savestate
vboxmanage controlvm storage-worker-02 savestate
vboxmanage controlvm storage-worker-03 savestate

echo "Starting Workers"
vboxmanage controlvm worker-01 savestate
vboxmanage controlvm worker-02 savestate
vboxmanage controlvm worker-03 savestate
