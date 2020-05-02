#!/bin/bash

create_master_vm() {
    # Create VM
    vboxmanage createvm --name "master-0$1" --ostype "Ubuntu_64" --register --basefolder $2
    vboxmanage modifyvm "master-0$1" --ioapic on
    # Setup memory
    vboxmanage modifyvm "master-0$1" --memory 1536 --vram 128
    # Setup CPU, masters need 2 cores.
    vboxmanage modifyvm "master-0$1" --cpus 2
    vboxmanage modifyvm "master-0$1" --cpuexecutioncap 50
    # Setup network
    vboxmanage modifyvm "master-0$1" --nic1 bridged
    vboxmanage modifyvm "master-0$1" --bridgeadapter1 enp67s0f0
    # Create root disk
    vboxmanage createhd --filename $2/master-0$1/root_disk.vdi --size 10000 --format VDI
    vboxmanage storagectl "master-0$1" --name "SATA Controller" --add sata --controller IntelAhci
    vboxmanage storageattach "master-0$1" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $2/master-0$1/root_disk.vdi
    # Attach Ubuntu 20.20 server image
    vboxmanage storagectl "master-0$1" --name "IDE Controller" --add ide --controller PIIX4
    vboxmanage storageattach "master-0$1" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $2/ubuntu.iso
    vboxmanage modifyvm "master-0$1" --boot1 dvd --boot2 disk --boot3 none --boot4 none
    # Start VM
    vboxmanage startvm "master-0$1"
}

create_worker_vm() {
    # Create VM
    vboxmanage createvm --name "worker-0$1" --ostype "Ubuntu_64" --register --basefolder $2
    vboxmanage modifyvm "worker-0$1" --ioapic on
    # Setup memory
    vboxmanage modifyvm "worker-0$1" --memory 3072 --vram 128
    # Setup CPU
    vboxmanage modifyvm "worker-0$1" --cpus 2
    # Setup network
    vboxmanage modifyvm "worker-0$1" --nic1 bridged
    vboxmanage modifyvm "worker-0$1" --bridgeadapter1 enp67s0f0
    # Create root disk
    vboxmanage createhd --filename $2/worker-0$1/root_disk.vdi --size 10000 --format VDI
    vboxmanage storagectl "worker-0$1" --name "SATA Controller" --add sata --controller IntelAhci
    vboxmanage storageattach "worker-0$1" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $2/worker-0$1/root_disk.vdi
    # Attach Ubuntu 20.20 server image
    vboxmanage storagectl "worker-0$1" --name "IDE Controller" --add ide --controller PIIX4
    vboxmanage storageattach "worker-0$1" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $2/ubuntu.iso
    vboxmanage modifyvm "worker-0$1" --boot1 dvd --boot2 disk --boot3 none --boot4 none
    # Start VM
    vboxmanage startvm "worker-0$1"
}

create_storage_worker_vm() {
    # Create VM
    vboxmanage createvm --name "storage-worker-0$1" --ostype "Ubuntu_64" --register --basefolder $2
    vboxmanage modifyvm "storage-worker-0$1" --ioapic on
    # Setup memory
    vboxmanage modifyvm "storage-worker-0$1" --memory 4096 --vram 128
    # Setup CPU
    vboxmanage modifyvm "storage-worker-0$1" --cpus 2
    # Setup network
    vboxmanage modifyvm "storage-worker-0$1" --nic1 bridged
    vboxmanage modifyvm "storage-worker-0$1" --bridgeadapter1 enp67s0f0
    # Create root disk
    vboxmanage createhd --filename $2/storage-worker-0$1/root_disk.vdi --size 10000 --format VDI
    vboxmanage storagectl "storage-worker-0$1" --name "SATA Controller" --add sata --controller IntelAhci
    vboxmanage storageattach "storage-worker-0$1" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $2/storage-worker-0$1/root_disk.vdi
    # Create data disk
    vboxmanage createhd --filename $2/storage-worker-0$1/data_disk.vdi --size 30000 --format VDI
    vboxmanage storageattach "storage-worker-0$1" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $2/storage-worker-0$1/data_disk.vdi
    # Attach Ubuntu 20.20 server image
    vboxmanage storagectl "storage-worker-0$1" --name "IDE Controller" --add ide --controller PIIX4
    vboxmanage storageattach "storage-worker-0$1" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $2/ubuntu.iso
    vboxmanage modifyvm "storage-worker-0$1" --boot1 dvd --boot2 disk --boot3 none --boot4 none
    # Start VM
    vboxmanage startvm "storage-worker-0$1"
}

# Check for args
if [ $# -eq 0 ]; then
    echo "Specify a directory to store the VMs"
    exit
fi

# Check if directory is not empty
if [ -z "$(ls -A $1)" ]; then
    # Download Ubuntu image
    wget -c https://releases.ubuntu.com/20.04/ubuntu-20.04-live-server-amd64.iso -O $1/ubuntu.iso
    # Create our masters
    create_master_vm 1 $1
    create_master_vm 2 $1
    create_master_vm 3 $1
    # Create our workers
    create_worker_vm 1 $1
    create_worker_vm 2 $1
    create_worker_vm 3 $1
    create_worker_vm 4 $1
    # Create our storage workers
    create_storage_worker_vm 1 $1
    create_storage_worker_vm 2 $1
    create_storage_worker_vm 3 $1
else
    echo "Directory $1 must be empty"
fi
