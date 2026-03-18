# 💾 Ansible K3s Cluster Deployment
[![Static Badge](https://img.shields.io/badge/Ansible-Automation-white?style=flat&logo=ansible&logoColor=white&logoSize=auto&labelColor=black)](https://docs.ansible.com/)
[![Static Badge](https://img.shields.io/badge/K3s-Kubernetes-white?style=flat&logo=k3s&logoColor=white&logoSize=auto&labelColor=black)](https://k3s.io/)

Automated deployment and management of a K3s Kubernetes cluster using Ansible. This project enables easy setup and teardown of a multi-node K3s cluster, connecting to an external database, and dedicated control plane and agent nodes.

## ✨ Features

- Automated K3s cluster deployment and uninstallation
- Multi-node support with control plane and agent nodes
- External database integration
- Comprehensive templating for K3s server and agent configurations
- Detailed status reporting and health checks
- Idempotent operations - safe to re-run

## 🚀 Quick Start

1. Configure your inventory and variables (see Configuration section)

2. Install K3s cluster:
   ```bash
   ansible-playbook -i hosts k3s-install.yaml -K
   ```
3. Uninstall K3s cluster (if needed):
   ```bash
   ansible-playbook -i hosts k3s-uninstall.yaml -K
   ```

## 🔧 Configuration

1. Configure your inventory in `hosts`:
   ```ini
   [control_plane]
   cp1 ansible_host=192.168.1.2
   cp2 ansible_host=192.168.1.3

   [agents]
   agent1 ansible_host=192.168.1.4
   agent2 ansible_host=192.168.1.5
   ```

2. Set K3s version in `group_vars/all.yaml`:
   ```yaml
   k3s_version: "v1.31.5+k3s1"
   ```

3. Configure K3s server settings in `templates/k3s-server-config.yaml.j2`:
   - Uncomment and set values as needed
   - **Permanent flags** (cannot be changed after first boot): `datastore-endpoint`, `cluster-cidr`, `service-cidr`, `flannel-backend`, `token`, etc.
   - **CNI options**: Set `flannel-backend: "none"` to use Cilium or Calico instead of Flannel
   - **Component flags**: Disable traefik, servicelb, etc. as needed

4. Configure K3s agent settings in `templates/k3s-agent-config.yaml.j2`:
   - Uncomment and set values as needed
   - Configure `server` and `token` to join the cluster

5. (Optional) For external etcd with TLS, place certificates in `certs/` directory:
   ```
   certs/
   ├── ca-bundle.crt
   ├── etcd-client.crt
   └── etcd-client.key
   ```
   These will be automatically copied to `/etc/rancher/k3s/certs/` on control plane nodes.

## 📝 Directory Structure

```
ansible-k3s/
├── certs/                              # (Optional) etcd TLS certificates
│   ├── ca-bundle.crt
│   ├── etcd-client.crt
│   └── etcd-client.key
├── group_vars/
│   └── all.yaml                        # K3s version configuration
├── templates/
│   ├── k3s-server-config.yaml.j2       # K3s server configuration template
│   └── k3s-agent-config.yaml.j2        # K3s agent configuration template
├── hosts                               # Ansible inventory file
├── k3s-install.yaml                    # Cluster installation playbook
├── k3s-uninstall.yaml                  # Cluster uninstallation playbook
├── LICENSE
└── README.md
```

## 🔍 Health Check

1. Check node status:
   ```bash
   kubectl get nodes
   ```

2. Check cluster health:
   ```bash
   kubectl get --raw /healthz
   ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🆘 Support

If you encounter any issues or need support, please file an issue on the GitHub repository.

## 📄 License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3.0 - see the [LICENSE](LICENSE) file for details.
