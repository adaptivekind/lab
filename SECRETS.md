# Ansible secret management

Some of the Ansible variables used by this collection are secret and sensitive.
They can be managed them in the following way.

## Initialisation

Create the local file `~/.ansible/secrets.yaml` with the following defined

Encrypt the vault using a personal password.

    ansible-vault encrypt ~/.ansible/secrets.yaml

Create symbolic link in the playbook repository to the secrets file.

    ln -s ~/.ansible/secrets.yaml group_vars/all/secrets.yaml

## Persistent login

Persistent log in can be achieved in the following way. This uses mac specific
approach. Similar approaches may be possible with other systems.

Log in with

    ~/.ansible/collections/ansible_collections/adaptivekind/lab/scripts/login_ansible_vault.sh

Install `direnv`

    brew install direnv

Add the file `.envrc` to the root of the playbook repository setting the
[ANSIBLE_VAULT_PASSWORD_FILE](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_VAULT_PASSWORD_FILE) to script that gets the vault password.

```txt
export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible/collections/ansible_collections/adaptivekind/lab/scripts/get_vault_password.sh
```

Then when ever you are in the project directory this variable will be loaded in
the shell such that you edit secrets file without having to re-enter the password, i.e.
run:

    ansible-vault encrypt ~/.ansible/secrets.yaml
