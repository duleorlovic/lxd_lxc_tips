# LXD LXC

First Steps

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

# duplicate instance ie copy
lxc copy ubuntu second

# lxc init buntu:22.04

lxc list

lxc info ubuntu
lxc config show ubuntu | grep description:

lxc stop ubuntu
lxc start ubuntu
lxc delete ubuntu
# or similar remove
lxc rm -f ubuntu

# alias, for example ip address of ubuntu
lxc alias add list-myname "list --format json | jq '.[] | select(.name == \"MyName\")'"
lxc alias add ip-ubuntu "list --format json | jq '.[] | select(.name == \"ubuntu\") | .state.network.eth0.addresses[] | select(.family == \"inet\").address'"

# run command on instance
lxc exec ubuntu -- free -m

# open shell, same as lxc exec ubuntu -- bash
lxc shell ubuntu

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
We can configure instance options
```
# show config
lxc config show ubuntu
lxc config show ubuntu --expanded
lxc config show ubuntu | grep "^description:"

# show description for all containers
lxc list -c n --format csv | while read container; do echo "Configuration for $container:"; lxc config show "$container"|grep "^description"; echo "----------"; done

# limit memory (default if 1GB)
lxc config set ubuntu limits.memory=128MiB
lxc exec ubuntu -- free -m
```

We can configure instance properties using `--property` flag using `set`,
`unset` and `get`
```
lxc onfig set <instance_name> <property_key>=<property_value> --property
```

And we can configure device `config device add`, `config devise set`, override
```
lxc config device add <instance_name> <device_name> <device_type> <device_option_key>=<device_option_value>
```
override disk size (default if 10GB)
```
lxc config device override ubuntu root size=30GiB
lxc restart ubuntu
lxc exec ubuntu -- df -h
```

# Profile

https://documentation.ubuntu.com/lxd/en/latest/profiles/
If not specified, `default` profile is used and it defines a network interface
and root disk.
```
lxc profile list
lxc profile show <profile_name>
lxc profile create <profile_name>
lxc profile edit <profile_name>
lxc profile set <profile_name> <option_key>=<option_value> <option_key>=<option_value>
lxc profile device add <profile_name> <device_name> <device_type> <device_option_key>=<device_option_value> <device_option_key>=<device_option_value>
# if device already exists in profile
lxc profile device set <profile_name> <device_name> <device_option_key>=<device_option_value> <device_option_key>=<device_option_value>
```

Apply profile to instance
```
lxc profile add <instance_name> <profile_name>
# or when launching
lxc launch <image> <instance_name> --profile <profile_name> --profile <profile_name>
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
# power_lxc

lxc list
# show the list of containers on power
```

## NIC Network

https://documentation.ubuntu.com/lxd/en/latest/howto/instances_routed_nic_vm/

# Maas

https://multipass.run/install

Install multipass
```
sudo snap install multipass
```

Commands
```
multipass list

multipass stop foo
multipass start foo
multipass delete foo
multipass purge foo
```

Pass cloud init
```
multipass launch -n bar --cloud-init cloud-config.yaml
```

TODO: https://maas.io/tutorials/build-a-maas-and-lxd-environment-in-30-minutes-with-multipass-on-ubuntu#4-check-whether-virtualisation-is-working
