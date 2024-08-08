Set hashed pi-hole passwiord in Ansible variable `pihole_hashed_password`

Some say the hash can be generated with

    pbpaste | sha256sum | cut -d ' ' -f 1 | sha256sum

However this doesn't match the one pi-hole creates. Instead I take the hashed
value from the `/etc/pihole/setupVars.conf` file.
