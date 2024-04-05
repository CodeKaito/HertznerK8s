# Ansible on Kubernetes
Playbook Ansible creati per configurare un cluster Kubernetes completamente automatizzato con un master e più nodi di lavoro. 
Funzionerà su server fisici, macchine virtuali, aws cloud, google cloud o qualsiasi altro server cloud. Questo è stato testato e verificato sui sistemi operativi Centos 7.3 a 64 bit. 
Inoltre è possibile fare riferimento a questo collegamento per la configurazione manuale

## Files nel root dir

### Configurazione del cluster e dei prerequisiti

1. settingup_kubernetes_cluster.yml

```yml
---
- import_playbook: playbooks/prerequisites.yml
- import_playbook: playbooks/setting_up_nodes.yml
- import_playbook: playbooks/configure_master_node.yml
```

2. join_kubernetes_workers_nodes.yml

```yml
---
- import_playbook: playbooks/configure_worker_nodes.yml
```

## Environment variables
File env_variables per le variabili d'ambiente

## Swap disabling
Poiché l'abilitazione dello swap consente un maggiore utilizzo della memoria per i carichi di lavoro in Kubernetes che non possono essere previsti con precisione, aumenta anche il rischio di "vicini rumorosi" e configurazioni di impacchettamento impreviste, poiché lo scheduler non può tener conto dell'utilizzo della memoria di swap.

```yml
---
- hosts: all
  vars_files:
  - env_variables
  tasks:
  - name: Disabling Swap on all nodes
    shell: swapoff -a

  - name: Commenting Swap entries in /etc/fstab
    replace:
     path: /etc/fstab
     regexp: '(.*swap*)'
     replace: '#\1'

```

## Configurazione del master node
```yml
---
- hosts: kubernetes-master-nodes
  vars_files:
  - env_variables 
  tasks:
  - name: Pulling images required for setting up a Kubernetes cluster
    shell: kubeadm config images pull

  - name: Initializing Kubernetes cluster
    shell: kubeadm init --apiserver-advertise-address {{ad_addr}} --pod-network-cidr={{cidr_v}}
    register: output

  - name: Storing Logs and Generated token for future purpose.
    local_action: copy content={{ output.stdout }} dest={{ token_file }}

  - name: Copying required files
    shell: |
     mkdir -p $HOME/.kube
     sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
     sudo chown $(id -u):$(id -g) $HOME/.kube/config

  - name: Install Network Add-on
    command: kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

1. hosts: kubernetes-master-nodes: Specifica che questo playbook verrà eseguito solo sui nodi master di Kubernetes.

2. vars_files: Specifica un file (presumibilmente denominato env_variables) che contiene le variabili utilizzate nel playbook.

3. tasks: Questa è la sezione principale del playbook, che elenca una serie di compiti da eseguire:

4. Pulling images required for setting up a Kubernetes cluster: Esegue uno script shell per tirare le immagini richieste per configurare un cluster Kubernetes.

5. Initializing Kubernetes cluster: Esegue l'inizializzazione del cluster Kubernetes utilizzando kubeadm init. Utilizza le variabili ad_addr e cidr_v per specificare l'indirizzo da cui il server API dovrebbe pubblicizzare e il CIDR per la rete dei pod.

7. Storing Logs and Generated token for future purpose: Copia i log e il token generato durante l'inizializzazione del cluster in un file specificato dalla variabile token_file.

8. Copying required files: Crea la directory ~/.kube e copia il file di configurazione del cluster Kubernetes (admin.conf) in essa, quindi imposta i permessi appropriati sul file.

9. Install Network Add-on: Utilizza il comando kubectl apply per applicare la configurazione del plugin di rete al cluster. In questo caso, si sta utilizzando Flannel come add-on di rete, scaricandone la configurazione da un URL remoto.

## Configurazione del worker node
```yml
---
- hosts: kubernetes-worker-nodes
  vars_files:
  - env_variables
  tasks:
  - name: Copying token to worker nodes
    copy: src={{ token_file }} dest=join_token

  - name: Joining worker nodes with kubernetes master
    shell: "`grep -i 'kubeadm join' join_token`"
```

1. hosts: kubernetes-worker-nodes: Specifica che questo playbook verrà eseguito solo sui nodi worker del cluster Kubernetes.

2. vars_files: Specifica un file (presumibilmente denominato env_variables) che contiene le variabili utilizzate nel playbook.

3. tasks: Questa è la sezione principale del playbook, che elenca una serie di compiti da eseguire:

  a. Copying token to worker nodes: Copia il token necessario per l'unione dei nodi worker al master Kubernetes dai file di configurazione specificati in token_file e lo colloca in un file chiamato join_token nei nodi worker.

  b. Joining worker nodes with Kubernetes master: Utilizza uno script shell per estrarre il comando di unione (kubeadm join) dal file join_token e lo esegue sui nodi worker per unirli al cluster gestito dal master       Kubernetes.

## Configurazione dei nodi

```yml
---
- hosts: all
  vars_files:
  - env_variables 
  tasks:
  - name: Creating a repository file for Kubernetes
    file:
     path: /etc/yum.repos.d/kubernetes.repo
     state: touch

  - name: Adding repository details in Kubernetes repo file.
    blockinfile:
     path: /etc/yum.repos.d/kubernetes.repo
     block: |
      [kubernetes]
      name=Kubernetes
      baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
      enabled=1
      gpgcheck=1
      repo_gpgcheck=1
      gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

  - name: Installing required packages
    yum:
     name: "{{ item }}"
     state: present
    with_items: "{{ packages }}"

  - name: Starting and Enabling the required services
    service:
     name: "{{ item }}"
     state: started
     enabled: yes
    with_items: "{{ services }}"

  - name: Allow Network Ports in Firewalld
    firewalld:
     port: "{{ item }}"
     state: enabled
     permanent: yes
     immediate: yes
    with_items: "{{ ports }}"

  - name: Enabling Bridge Firewall Rule
    shell: "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
```

1. hosts: all: Questo indica che il playbook verrà eseguito su tutti gli host specificati nel file di inventario di Ansible.
vars_files: Specifica un file (presumibilmente denominato env_variables) che contiene le variabili utilizzate nel playbook.

2. tasks: Questa è la sezione principale del playbook, che elenca una serie di compiti da eseguire:

3. Creating a repository file for Kubernetes: Crea un file di repository per Kubernetes in /etc/yum.repos.d/kubernetes.repo.

4. Adding repository details in Kubernetes repo file: Aggiunge i dettagli del repository nel file del repository di Kubernetes precedentemente creato.

5. Installing required packages: Utilizza il modulo yum per installare i pacchetti specificati nelle variabili packages.

6. Starting and Enabling the required services: Utilizza il modulo service per avviare e abilitare i servizi specificati nelle variabili services.

7. Allow Network Ports in Firewalld: Utilizza il modulo firewalld per abilitare le porte specificate nel firewall.

8. Enabling Bridge Firewall Rule: Esegue uno script shell per abilitare una regola del firewall del bridge.
