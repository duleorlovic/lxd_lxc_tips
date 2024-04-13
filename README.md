# First Steps
https://documentation.ubuntu.com/lxd/en/latest/tutorial/first_steps/

```
sudo snap install lxd
sudo snap refresh lxd
lxd init --minimal
```
Search images https://documentation.ubuntu.com/lxd/en/latest/images/#images
```
lxc image list ubuntu: 22.04 architecture=$(uname -m)
```

Commands
```
# Start instance as container
lxc launch ubuntu:22.04 ubuntu

# start as virtual VM with --vm
lxc launch ubuntu:22.04 ubuntu-vm --vm

# duplicate copy
lxc copy ubuntu second

lxc list

lxc info ubuntu
lxc stop ubuntu
lxc start ubuntu
lxc delete ubuntu

# run command on instance
lxc exec ubuntu -- free -m

# pull files
lxc file pull ubuntu/etc/hosts .

# copy to machine
lxc file push hosts ubuntu/etc/hosts


# create snapshot
lxc snapshot ubuntu my-snap
lxc restore ubuntu my-snap
```

# Configure

Configure options
https://documentation.ubuntu.com/lxd/en/latest/howto/instances_configure/#instances-configure
https://documentation.ubuntu.com/lxd/en/latest/reference/instance_options/#instance-options
https://documentation.ubuntu.com/lxd/en/latest/explanation/instance_config/#instance-config
```
# show config
lxc config show ubuntu

# limit memory (default if 1GB)
lxc config set ubuntu limits.memory=128MiB
lxc exec ubuntu -- free -m

# override disk size (default if 10GB)
lxc config device override ubuntu-vm root size=30GiB
lxc restart ubuntu-vm
lxc exec ubuntu-vm -- df -h
```

## UI Server remote access

https://documentation.ubuntu.com/lxd/en/latest/howto/server_expose/#server-expose
```
lxc config set core.https_address :8443

# generate token for the client
lxc config trust add --name lxd-ui

lxc config trust add --name mac_token
ABCtoken...
```

On macOS
```
brew install lxc
lxc remote add power_lxc power
Generating a client certificate. This may take a minute...
Certificate fingerprint:
70d76f...
ok (y/n/[fingerprint])? yes
Admin password (or token) for power_lxc: ABCtoken...
Client certificate now trusted by server: power_lxc

lxc remote switch power_lxc
lxc remote get-default

```

## NIC Network

https://documentation.ubuntu.com/lxd/en/latest/howto/instances_routed_nic_vm/
