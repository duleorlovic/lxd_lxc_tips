#!/bin/bash
# Usage:
#   lxc 
function get_container_ip() {
    container_name="$1"  # Get the container name from function argument

    # Use lxc list to get the IP address of the specified container
    # Adjust the jq filter to match your network interface and IP setup
    ip_address=$(lxc list "$container_name" --format=json | jq -r ".[] | select(.name == \"$container_name\") | .state.network.eth0.addresses[] | select(.family == \"inet\").address")

    # Check if an IP address was found
    if [ -z "$ip_address" ]; then
        echo "No IP address found for container $container_name."
    else
        echo "$ip_address"
    fi
}
