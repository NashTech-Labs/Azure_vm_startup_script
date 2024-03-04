#!/bin/bash

# Function to check if Azure VM is running
check_azure_vm() {
    vm_status=$(az vm show --resource-group "RESOURCE_GROUP_NAME" --name "VM_NAME" --query "powerState" -o tsv)
    if [ "$vm_status" == "VM running" ]; then
        return 0  # VM is running
    else
        return 1  # VM is not running
    fi
}

# Function to start the Azure VM if it's not running
start_azure_vm_if_not_running() {
    if ! check_azure_vm; then
        echo "Azure VM is not running. Starting it up..."
        az vm start --resource-group "RESOURCE_GROUP_NAME" --name "VM_NAME" &> /dev/null
    else
        echo "Azure VM is already running."
    fi
}

# Main script
start_azure_vm_if_not_running

# Wait until the Azure VM is running
while true; do
    if check_azure_vm; then
        echo "Azure VM is now running."
        break
    else
        echo "Waiting for Azure VM to start..."
        sleep 10  # Adjust the sleep time as needed
    fi
done
