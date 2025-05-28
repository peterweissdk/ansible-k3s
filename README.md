# 💾 Ansible K3s Cluster Deployment
[![Static Badge](https://img.shields.io/badge/Ansible-Automation-white?style=flat&logo=ansible&logoColor=white&logoSize=auto&labelColor=black)](https://docs.ansible.com/)
[![Static Badge](https://img.shields.io/badge/K3s-Kubernetes-white?style=flat&logo=k3s&logoColor=white&logoSize=auto&labelColor=black)](https://k3s.io/)

Automated deployment and management of a K3s Kubernetes cluster using Ansible. This project enables easy setup and teardown of a multi-node K3s cluster with dedicated control plane and agent nodes.

## ✨ Features

- Automated K3s cluster deployment and uninstallation
- Multi-node support with control plane and agent nodes
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

2. Update configuration in `group_vars/all.yaml`:
   ```yaml
   k3s_version: "v1.31.5+k3s1" # Specify K3s version to install
   k3s_token: "your_secure_token" # Security token for cluster formation
   db_endpoint: "mysql://user:pass@host:3306/k3s" # MySQL database connection string
   api_endpoint: "your_api_ip" # IP address where the Kubernetes API will be exposed

3. Enable / Disable default components : 
   ```bash
   - Remove `--disable=traefik` to keep the built-in Traefik ingress controller
   - Remove `--disable=servicelb` to use the built-in ServiceLB load balancer
   - Remove `--datastore-endpoint` to use the default embedded etcd instead of external database
   ```

4. Example installation command with defaults:
   ```bash
   curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.31.5+k3s1 sh -s - server \
      --token=your_secure_token \
      --tls-san=your_api_ip
   ```

## 📝 Directory Structure

```
ansible-k3s/
├── group_vars/
│   └── all.yaml
├── hosts
├── k3s-install.yaml
├── k3s-uninstall.yaml
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
