# Chef Workstation
[![](https://images.microbadger.com/badges/image/bfscloud/chef-workstation.svg)](https://microbadger.com/images/bfscloud/chef-workstation)
[![](https://images.microbadger.com/badges/version/bfscloud/chef-workstation.svg)](https://microbadger.com/images/bfscloud/chef-workstation)

This is a wrapper container designed for the latest stable [Chef Workstation](https://downloads.chef.io/chef-workstation/stable).

Rather than running as root, this image adds a `chef` user and a custom entrypoint wrapping `kitchen` commands.
