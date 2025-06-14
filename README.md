# Ansible Collection - adaptivekind.lab

Collection of resources to build a research lab environment hosted by Raspberry Pis. This bootstraps a system with:

- Caddy for front door routing and SSL certificate generation
- Pi-hole for DNS resolution and ad blocking
- WireGuard for VPN
- Git repository hosting
- NFS
- k3s and ArgoCD referencing an app of apps repository to run other services

An output of this is Kubernetes cluster with the ArgoCD driven from an [app of
apps](https://github.com/adaptivekind/app-of-apps) repository.

## Usage

Create an Ansible playbook repository that will use this collection. Useful to
source control this repository, e.g. manage as a git repository.

Create `roles/requirements.yaml` file containing:

```yaml
collections:
  - name: git@github.com:adaptivekind/lab.git
    type: git
    version: main
```

Install collection

```sh
ansible-galaxy install -r roles/requirements.yaml
```

Crete `inventory.yaml`, e.g.

```yaml
prime:
  hosts:
    a1:
  vars:
k3s_cluster:
  children:
    server:
      hosts:
        a2:
    agent:
      hosts:
        a3:
```

## Collection Variables

Key variables that probably need to customised are described below. Other variables are documented in the specific roles where used.

| Variable               | Default  | Purpose                                        |
| ---------------------- | -------- | ---------------------------------------------- |
| cloudflare_api_key     | none     | Domain verification for certificate generation |
| crypt_passphrase       | none     | Passphrase for encrypted disk                  |
| grafana_password       |          |                                                |
| lab_domain             | `.local` | Domain naming and certificate generation       |
| pihole_hashed_password |          |                                                |
| token                  | none     | k3s cluster token                              |

Secrets can be managed in an [Ansible
vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html). See
[./SECRETS.md](managing secrets) on how this can be set this up.

Cloudflare API token should have `Zone.Zone:Read` and `Zone.DNS:Edit`
permissions for the lab domain. See [Cloudflare module for Caddy
](https://github.com/caddy-dns/cloudflare)

## Run playbook with

Run playbook with

    ansible-playbook -i inventory.yaml adaptivekind.lab.site

Run specific playbook, e.g. cluster install

    ansible-playbook -i inventory.yaml adaptivekind.lab.cluster

Or run just specifically tagged roles in a specific playbook

    ansible-playbook -i inventory.yaml adaptivekind.lab.prime --tags pihole

## Set Argo CD password

To access the Argo CD console, the password need to be retrieved and preferably
updated.

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | 
  base64 -d | pbcopy
argocd login argocd.<use lab_domain value> --grpc-web
argocd account update-password
```

## Troubleshooting

Reset ArgoCD admin password

<https://medium.com/@dulanjanalakmal/securing-argocd-a-step-by-step-guide-to-resetting-admin-passwords-bb5236208a64>
