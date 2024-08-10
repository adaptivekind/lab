# Ansible Collection - adaptivekind.lab

Collection of resources to build my lab environment. This bootstraps a system with:

- Caddy for front door routing and SSL certificate generation
- Pi-hole for DNS resolution and ad blocking
- WireGuard for VPN
- Git repository hosting
- NFS
- k3s and ArgoCD referencing an app of apps repository to run other services

## Collection Variables

Key variables that probably need to customised

| Variable               | Default  | Purpose                                        |
| ---------------------- | -------- | ---------------------------------------------- |
| cloudflare_api_key     | none     | Domain verification for certificate generation |
| crypt_passphrase       | none     | Passphrase for encrypted disk                  |
| grafana_password       |          |                                                |
| lab_domain             | `.local` | Domain naming and certificate generation       |
| pihole_hashed_password |          |                                                |
| token                  | none     |                                                |

Other variables are documented in the specific roles where used.

## Using

Create an Ansible playbook repository that will use this collection.

Create `roles/requirements.yaml` file, e.g

```yaml
collections:
  - name: git@github.com:ianhomer/lab.git
    type: git
    version: main
```

Install collection

```sh
ansible-galaxy install -r roles/requirements.yaml
```

Define the following secrets in an ansible-vault

- `cloudflare_api_key` - api key DNS verification by let's encrypt and Caddy
- `crypt_passphrase` - passphrase for encrypted drive
- `token` - k3s cluster token

You can encrypt such a vault with

    ansible-vault encrypt ~/.ansible/secrets.yaml

Add on a mac log in with

    ~/.ansible/collections/ansible_collections/ianhomer/lab/scripts/login_ansible_vault.sh

Crete `inventory.yaml`, e.g.

```yaml
all:
  hosts:
    angus:
  vars:
    ansible_ssh_user: admin
    ansible_python_interpreter: /usr/bin/python3.11
k3s_cluster:
  children:
    server:
      hosts:
        angus:
```

## Run playbook with

Run site playbook with

    ansible-playbook -i inventory.yaml ianhomer.lab.site

Run cluster playbook with

    ansible-playbook -i inventory.yaml ianhomer.lab.cluster

Run just one role

    ansible-playbook -i inventory.yaml ianhomer.lab.site --tags docker
