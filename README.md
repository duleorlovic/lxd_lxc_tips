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
lxc launch ubuntu:22.04 my-instance

# start as virtual VM with --vm
lxc launch ubuntu:22.04 ubuntu-vm --vm

# duplicate instance ie copy
lxc copy ubuntu second

# lxc init buntu:22.04

lxc list

lxc info my-instance
lxc config show my-instance | grep description:

lxc stop my-instance
lxc start my-instance
lxc delete my-instance
# or similar remove
lxc rm -f my-instance

# alias, for example ip address of my-instance
lxc alias add list-myname "list --format json | jq '.[] | select(.name == \"MyName\")'"
lxc alias add ip-ubuntu "list --format json | jq '.[] | select(.name == \"my-instance\") | .state.network.eth0.addresses[] | select(.family == \"inet\").address'"

# run command on instance
lxc exec my-instance -- free -m

# open shell, same as lxc exec my-instance -- bash
lxc shell my-instance

# pull files
lxc file pull my-instance/etc/hosts .

# copy to machine
lxc file push hosts my-instance/etc/hosts


# create snapshot
lxc snapshot my-instance my-snap
lxc restore my-instance my-snap
```

# Configure

Configure options
https://documentation.ubuntu.com/lxd/en/latest/howto/instances_configure/#instances-configure
https://documentation.ubuntu.com/lxd/en/latest/reference/instance_options/#instance-options
https://documentation.ubuntu.com/lxd/en/latest/explanation/instance_config/#instance-config
We can configure instance options
```
# show config
lxc config show my-instance
lxc config show my-instance --expanded
lxc config show my-instance | grep "^description:"

# show description for all containers
lxc list -c n --format csv | while read container; do echo "Configuration for $container:"; lxc config show "$container"|grep "^description"; echo "----------"; done

# limit memory (default if 1GB)
lxc config set my-instance limits.memory=128MiB
lxc exec my-instance -- free -m

# if you run docker under image
lxc config set my-instance security.nesting true
```

We can configure instance properties using `--property` flag using `set`,
`unset` and `get`
```
lxc config set my-instance <property_key>=<property_value> --property
```

And we can configure device `config device add`, `config devise set`, override
```
lxc config device add my-instance my_device_name <device_type> <device_option_key>=<device_option_value>
```
override disk size (default if 10GB)
```
lxc config device override my-instance root size=30GiB
lxc restart my-instance
lxc exec my-instance -- df -h
```

# Profile

https://documentation.ubuntu.com/lxd/en/latest/profiles/
If not specified, `default` profile is used and it defines a network interface
and root disk.
```
lxc profile list
lxc profile show my_profile_name
lxc profile create my_profile_name
lxc profile delete my_profile_name
lxc profile edit my_profile_name

lxc profile set my_profile_name <option_key>=<option_value> <option_key>=<option_value>

lxc profile device add my_profile_name my_device_name <device_type> <device_option_key>=<device_option_value> <device_option_key>=<device_option_value>
lxc profile device add mainlan eth0 nic nictype=bridged parent=bridge0 # bridge0 is host device

# if device already exists in profile
lxc profile device set my_profile_name my_device_name <device_option_key>=<device_option_value> <device_option_key>=<device_option_value>
```

Apply profile to instance
```
lxc profile add my_instance my_profile_name
# or when launching
lxc launch ubuntu:22.04 my-instance --profile default --profile my_profile_name
```

https://documentation.ubuntu.com/lxd/en/latest/cloud-init/
Cloud config user data can be added to profile, note that it is with dash not
underscore `config: cloud-init.user-data: #cloud-config ` (not `user_data`)
Cloud init can be passed as `vendor-data` and `user-data` and `network-config`
https://documentation.ubuntu.com/lxd/en/latest/cloud-init/#how-to-specify-network-configuration-data
Example is in `profile_user_data/install_package.yaml` and
`profile_network_config/add_routed_nic_device.yaml`




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
