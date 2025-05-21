#!/bin/bash

export user=$(whoami)
export projectName="mottu-mapping"
export RESOURCE_GROUP="rg-${projectName}"
export VM_NAME="vm-${projectName}"
export LOCATION="brazilsouth"
export USERNAME="mappingadmin"
export IMAGE="Oracle:Oracle-Linux:ol810-lvm-gen2:8.10.1"
export STORAGE_SKU_OS="StandardSSD_LRS"
export STORAGE_SKU_HDD="Standard_LRS"
export SIZE="Standard_B2s"
export SSH_KEY="~/.ssh/id_rsa"