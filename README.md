# Ansible Collection - ianhomer.lab

Collection of resources to build my lab environment.  Bootstrapped stack is essentially

- Caddy for front door routing and SSL certificate generation
- Pi-hole for DNS resolution and ad blocking
- WireGuard for VPN
- Git repository hosting
- NFS
- k3s for kubernetes stack and running on most workloads. 

GitOps CD with ArgoCD manages the workload on the k8s stack, i.e. not Ansible
responsibility.

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

Run with

    ansible-playbook -i inventory.yaml ianhomer.lab.site

Run just one role

    ansible-playbook -i inventory.yaml ianhomer.lab.site --tags docker
