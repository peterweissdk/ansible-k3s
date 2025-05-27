# 💾 Ansible K3s Cluster Deployment

Automated deployment and management of a K3s Kubernetes cluster using Ansible. This project enables easy setup and teardown of a multi-node K3s cluster with dedicated control plane and agent nodes.

## ✨ Features

- Automated K3s cluster deployment and uninstallation
- Multi-node support with control plane and agent nodes
- MySQL database backend for high availability
- Serial processing for controlled cluster operations
- Configurable node roles (control plane/agent)
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
   k3s_version: "v1.31.5+k3s1"
   k3s_token: "your_secure_token"
   db_endpoint: "mysql://user:pass@host:3306/k3s"
   api_endpoint: "your_api_ip"
   ```

Configuration variables:
- **k3s_version**: Specify K3s version to install
- **k3s_token**: Security token for cluster formation
- **db_endpoint**: MySQL database connection string
- **api_endpoint**: Kubernetes API endpoint IP

## 📝 Directory Structure

```
ansible-k3s/
├── group_vars/
│   └── all.yaml         # Global variables
├── hosts                # Inventory file
├── k3s-install.yaml    # Installation playbook
└── k3s-uninstall.yaml  # Uninstallation playbook
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
