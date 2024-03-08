# tactiq.io Free YouTube Transcript

## Kubernetes in Hetzner Cloud with Terraform, Kubespray, HCLOUD Controller Manager, and Storage Driver

YouTube Link: [Kubernetes in Hetzner Cloud](https://www.youtube.com/watch/S424jkxtEf0)

### Introduction
In this video, we'll guide you through the process of setting up Kubernetes in Hetzner Cloud. Hetzner Cloud is a popular choice among cloud enthusiasts due to its affordability, user-friendliness, and robust API. While Hetzner Cloud doesn't offer a managed Kubernetes service, we'll leverage tools from the Hetzner Cloud GitHub project to simplify the setup.

### Tools Used
1. **Hetzner Cloud Controller Manager**: Integrates Kubernetes clusters with the Hetzner Cloud API, enabling features like private networks and load balancers.
2. **Hetzner Cloud CSI Driver**: Facilitates the creation of Hetzner Cloud storage volumes directly through Kubernetes persistent volume claims.

### Infrastructure Setup with Terraform
1. Create a new project in the Hetzner Cloud console.
2. Use Terraform, an infrastructure-as-code tool, to deploy the project's infrastructure.
3. Configure Terraform with a Hetzner Cloud API token.
4. Define the project's infrastructure, including a jump server and Kubernetes nodes.
5. Initialize and deploy the infrastructure using Terraform.

### Kubernetes Cluster Deployment with Kubespray
1. Log into the jump server and clone the Kubespray project.
2. Install Ansible on the jump server.
3. Create a Python virtual environment and install Ansible and dependencies.
4. Generate an inventory file containing the private IP addresses of Kubernetes nodes.
5. Configure the Kubernetes cluster with custom settings for Hetzner Cloud.
6. Deploy the Kubernetes cluster using Kubespray and Ansible.

### Verifying the Cluster
1. Install `kubectl` on the jump server to interact with the Kubernetes cluster.
2. Copy the kubeconfig file from a control plane node to the jump server.
3. Test the cluster connection with `kubectl get nodes`.

### Load Balancer Setup
1. Deploy a sample web app using Kubernetes Services.
2. Set annotations for Hetzner Cloud load balancer configurations.
3. Simplify load balancer configurations with a ConfigMap.

### Hetzner Cloud CSI Driver Setup
1. Create a secret containing the Hetzner Cloud API token for the CSI driver.
2. Apply the CSI driver manifest to the Kubernetes cluster.
3. Verify the CSI driver deployment and storage class creation.
4. Create a Persistent Volume Claim (PVC) and a Pod to test the CSI driver.

### Conclusion
This comprehensive guide equips you with the knowledge to set up a complete Kubernetes cluster with networking, load balancing, and managed storage in Hetzner Cloud. Find the project details, code, and commands in the GitHub repository linked in the description.

Enjoy the video, and feel free to like and subscribe!
