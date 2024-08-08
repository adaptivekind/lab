Generate pi-hole hashed password with

    pbpaste | sha256sum | cut -d ' ' -f 1 | sha256sum

And set in Ansible variable `pihole_hashed_password`
