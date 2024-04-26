# HetznerK8s

## Descrizione progetto
Creazione di un cluster K8s su Hetzner composto da tre nodi (master, worker). Dovrà essere possibile creare/distruggere l’ambiente al bisogno, quindi si consiglia di utilizzare dei tool di automazione per la configurazione ed il provisioning delle macchine (es: Ansible e Terraform).

![image](https://github.com/CodeKaito/HetznerK8s/assets/57111980/f643bed6-9b75-4041-b86a-5083ac32ab51)


## Perché Hertzner?
Hetzner Cloud offre una vasta gamma di servizi ideali per lo sviluppo di architetture cloud. Ciò che distingue Hetzner Cloud dagli altri provider cloud è la sua interfaccia utente intuitiva e l'API user-friendly, la presenza dei datacenter in Europa e i suoi prezzi altamente competitivi rispetto a concorrenti come GCP, Azure e AWS.

### Virtual Machines
Hetzner offre diverse tipologie di macchine virtuali progettate per soddisfare le esigenze di elaborazione e carichi di lavoro.
Per questo progetto utilizziamo la categoria Shared vCPU(x86), questa categoria offre un equilibrio tra prestazioni,flessibilità e costi. Queste vm, sono adatte per una vasta gamma di carichi di lavoro generici, come siti web, applicazioni di piccole e medie dimensioni, server di database, ecc. 
Per il Master Node e i due Worker Nodes di Kubernetes, optiamo per la VM CX21. Pur essendo di fascia inferiore, questa VM offre risorse adeguate per svolgere il ruolo di master node in un cluster Kubernetes. Con una CPU a 4 core, 4 GB di RAM e un SSD da 40 GB, fornisce solitamente prestazioni sufficienti per gestire le funzionalità di gestione e coordinamento del cluster.

### Network & Subnetwork
Per abilitare la comunicazione tra gli host, abbiamo configurato la risorsa di rete di Hetzner. Questo ci consente di assegnare un indirizzo IP pubblico e un indirizzo IP privato a ciascun host della nostra rete.

## Componenti
### API Hetzner 
L'API key è fondamentale per l'accesso e l'autenticazione tramite API al servizio cloud di Hetzner. Funge da chiave di identificazione e autorizzazione, consentendo l'esecuzione di operazioni automatizzate o gestite tramite l'API del provider.
Con l'API key, è possibile automatizzare le operazioni di gestione delle risorse cloud, come la creazione, la modifica o l'eliminazione di istanze di server del cluster K8s e la gestione delle reti. Questo permette di implementare e gestire l'infrastruttura cloud sfruttando l’IaC, semplificando e ottimizzando i processi di gestione delle risorse.

Endpoint principale: https://api.hetzner.cloud/v1
Autenticazione: Hetzner Cloud utilizza autenticazione su token. Per effettuare una richiesta, è necessario mettere nell'header il Bearer <API_TOKEN>, esempio:
```bash
 curl -H 'Authorization: Bearer <API_TOKEN>' \

        -H 'Content-Type: application/json' \

        -d '{ "name": "server01", "server_type": "cx21", "location": "nbg1", "image": "ubuntu-22.04"}' \

        -X POST 'https://api.hetzner.cloud/v1/servers'
```

# Terraform 
## Concetti di base di Terraform
Terraform è uno strumento open-source sviluppato da HashiCorp che consente la gestione dell'infrastruttura come codice (Infrastructure as Code - IaC). In pratica,
Terraform consente agli sviluppatori e agli amministratori di configurare, modificare e gestire l'infrastruttura IT in modo automatizzato utilizzando semplici
dichiarazioni di configurazione.

### Casi d'uso comuni per Terraform 
Terraform è uno strumento che gestisce il ciclo di vita completo delle risorse infrastrutturali, dalla creazione e modifica all'eliminazione, garantendo la coerenza dello stato dell'infrastruttura. 
Le sue principali caratteristiche includono la capacità di creare un grafico delle dipendenze tra le risorse specificate nel file di configurazione, assicurando che vengano create e gestite nell'ordine corretto. 
Prima di apportare modifiche all'infrastruttura, Terraform fornisce una pianificazione delle azioni da eseguire, consentendo agli utenti di revisionare e confermare le modifiche proposte. 
Inoltre, Terraform utilizza moduli che consentono di organizzare e riutilizzare porzioni di codice di configurazione. Poiché il codice di configurazione di Terraform è testo semplice, può essere facilmente versionato utilizzando sistemi di controllo del codice sorgente come Git. Queste caratteristiche lo rendono ideale per deployare e gestire l'infrastruttura su Hetzner Cloud.

#### Proprietá chiave di Terraform e perché abbiamo scelto di utilizzarlo:
1. Gestione dell'infrastruttura con IaC: Terraform consente di definire l'intera infrastruttura come codice, consentendo di gestire e versionare l'intera configurazione come parte del repository del codice sorgente. Questo offre controllo e riproducibilità dell'intero cluster.
2. Automazione del provisioning: Terraform automatizza il processo di provisioning dell'infrastruttura, consentendo di creare e configurare facilmente tutte le risorse necessarie per il nostro cluster Kubernetes.
3. Gestione delle dipendenze e dell'ordine di creazione: Terraform gestisce automaticamente le dipendenze tra le risorse e garantisce che vengano create nell'ordine corretto. Ad esempio, le risorse di rete vengono create prima delle istanze VM che dipendono da esse.
4. Scalabilità e gestione del ciclo di vita: Terraform facilita la scalabilità dell'infrastruttura, consentendo di gestire facilmente l'espansione o la riduzione del cluster Kubernetes in base alle esigenze del workload.

### Configurazione dell'ambiente di sviluppo per Terraform
Installazione di Terraform:
Per installare Terraform, segui le istruzioni nella documentazione ufficiale disponibile all'indirizzo: https://developer.hashicorp.com/terraform/install?product_intent=terraform

### Interazione con il provider cloud:
Per interagire con la dashboard di Hetzner da Terraform, utilizzeremo l'API descritta in precedenza.

### Inizializzazione del progetto:
Per inizializzare il progetto Terraform, naviga nella directory contenente i file di Terraform e esegui il comando `terraform init`. Questo processo scaricherà tutti i plugin necessari e inizializzerà l'ambiente di lavoro.

### Pianificazione delle modifiche:
Utilizzare il comando `terraform plan` per visualizzare una pianificazione delle azioni che Terraform eseguirà una volta applicato. Questo ti consente di controllare e confermare le modifiche proposte prima del deploy effettivo.

### Applicazione delle modifiche:
Una volta verificate le modifiche proposte, esegui il comando `terraform apply`. Terraform eseguirà le azioni pianificate e creerà le risorse nel cloud in base alla configurazione definita.

## Componenti principali
### Provider.tf

Creare un file provider.tf con il seguente contenuto, questo file configura Terraform per interagire con Hetzner Cloud utilizzando il provider "hcloud", specificando il token API e la versione di Terraform richiesta.
```bash
# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.HCLOUD_API_TOKEN}"
}

terraform {
    required_providers {
        hcloud = {
        source = "hetznercloud/hcloud"}
      }
    
  
    required_version = ">= 0.14"
}
```

### Network.tf
Questo file configura la network per il cluster in cloud con l'intervallo IP specificato è "172.16.0.0/24".
```bash
resource "hcloud_network" "kubernetes-node-network" {
  name     = "kubernetes-node-network"
  ip_range = "172.16.0.0/24"
}

resource "hcloud_network_subnet" "kubernetes-node-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.kubernetes-node-network.id
  network_zone = "eu-central"
  ip_range     = "172.16.0.0/24"
}
```

### Servers.tf
Creazione delle vm e assegnazione delle specifiche quali nome della vm, il tipo di vm, il datacenter, la chiave ssh per connettersi.
```bash
resource "hcloud_server" "kube-master" {
  name = "kube-master"
  image = "rocky-9" #
  server_type = "cx21"
  datacenter  = "hel1-dc2"
  ssh_keys = [ "id_extraordy_challenge" ]

  network {
    network_id = hcloud_network.kubernetes-node-network.id
    ip         = "172.16.0.120"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  depends_on = [
    hcloud_network_subnet.kubernetes-node-subnet
  ]

}

resource "hcloud_server" "kube-worker" {
  count       = 2
  name        = "kube-worker-${count.index + 1}"
  image       = "rocky-9"
  server_type = "cx21"
  datacenter  = "hel1-dc2"
  ssh_keys = [ "id_extraordy_challenge" ]

  network {
    network_id = hcloud_network.kubernetes-node-network.id
    ip         = "172.16.0.12${count.index + 1}"
  }

}
```

### Variables.tf
Creare file per la conservazione dell'api token di Hcloud.
```bash
#Define terraform variables
variable "HCLOUD_API_TOKEN" {
  type = string
  sensitive = true
}
```

### Inventory.tf
Il file inventory.yaml che utilizzerà ansible in fase di configurazione viene generato da terraform e modificato in fase di runtime.
```bash
resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.yaml"

  content = <<EOT
all:
  hosts:
    kube-master:
      ansible_host: ${hcloud_server.kube-master.ipv4_address}
    kube-worker-1:
      ansible_host: ${hcloud_server.kube-worker[0].ipv4_address}
    kube-worker-2:
      ansible_host: ${hcloud_server.kube-worker[1].ipv4_address}

workers:
  hosts:
    kube-worker-1:
      ansible_host: ${hcloud_server.kube-worker[0].ipv4_address}
    kube-worker-2:
      ansible_host: ${hcloud_server.kube-worker[1].ipv4_address}
EOT
}
```

# Kubernetes
## Concetti di base di Kubernetes: MasterNode & WorkersNode
Il masternode è il nodo principale o il controller di un cluster Kubernetes.

Gestisce le operazioni globali del cluster, come la pianificazione dei pod e il monitoraggio dello stato del cluster.
Componenti principali del masternode:
1. API Server: Esposizione dell'API del cluster Kubernetes.
2. Controller Manager: Gestisce il cluster.
3. Scheduler: Pianifica i pod sui nodi del cluster.
4. Etcd: Archivia lo stato del cluster.

Workernode:
Il workernode è un nodo di esecuzione nel cluster Kubernetes ed esegue i workload delle applicazioni come i container dei pod.
Componenti principali del workernode:
1. Kubelet: Agisce come agente su ogni nodo del cluster e gestisce i pod.
2. Kube-proxy: Gestisce il networking del cluster.
3. Container Runtime: Software che esegue i container, come Docker o containerd.

## Installazione e configurazione di un cluster K8S su HC
### Set degli ip e hostname dentro /etc/hosts
Inserimento degli ip e hostname in ciascuna macchina del cluster per risolvere i nomi degli altri nodi, ed avere un comunicazione interna affidabile ed efficiente.
```bash
vi /etc/hosts/ //inserimento degli ip e hostnames all interno di /etc/hosts

65.108.55.88    kube-master // Inserisci ip e hostname del nodo master
37.27.27.253    kube-worker-1 // Inserisci ip e hostname del nodo worker1
37.27.26.72     kube-worker-2 // Inserisci ip e hostname del nodo worker2
```

### Disabilitare SWAP su tutti i nodi
Affinché kubelet funzioni senza intoppi, dobbiamo disabilitare lo spazio di swap su tutti i nodi. Run:
```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### Modifica le regole di SELinux e del firewall per Kubernetes
Utilizziamo modalità permissiva anziché disabilitare completamente SELinux per di mantenere un livello di sicurezza sul sistema. Sebbene SELinux non sia attivo nella modalità permissiva, continua comunque a registrare le violazioni delle politiche, il che consente di identificare e risolvere eventuali problemi di sicurezza.
```bash
sudo setenforce 0
sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/sysconfig/selinux
```

### Aggiunta di Moduli e Parametri per containerd 
Moduli per la corretta esecuzione di containerd all'avvio del sistema
```bash
sudo tee /etc/modules-load.d/containerd.conf <<EOF
> overlay
> br_netfilter
> EOF
```
Per rendere effettive le modifiche, run:
```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```

### Aggiunta di Configurazioni e Parametri per kubernetes 
Impostazioni per garantire che il networking tra i container e altre funzionalità di rete funzionino correttamente all'interno del cluster.
```bash
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
> net.bridge.bridge-nf-call-ip6tables = 1
> net.bridge.bridge-nf-call-iptables = 1
> net.ipv4.ip_forward = 1
EOF
```

```bash
sudo vi /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
```
Per convalidare le modifiche, run:
```bash
sudo sysctl --system
```

### Installazione del Containerd Runtime
Aggiungere il repository Docker CE al sistema CentOS.
```bash
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
Installazione del runtime di container containerd.io.
```bash
sudo dnf install containerd.io -y
```
Configura containerd in modo che utilizzi systemdcgroup, esegui i seguenti comandi su ciascun nodo.
```bash
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd
sudo systemctl status containerd
```

### Installazione del tool di kubernetes
Gli strumenti Kubernetes come Kubeadm, kubectl e kubelet non sono disponibili nei repository di pacchetti predefiniti di Rocky Linux 9 o AlmaLinux 9
```bash
$ cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
```

```bash
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet // Starta il kubelet in ogni nodo
```

### Inizializzazione del master node
Runnare dal master node:
```bash
sudo kubeadm init --control-plane-endpoint=<hostname_masternode>
```
Per iniziare ad interagire con il masternode:
```bash
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Lanciare quindi il comando `kubeadm token create --print-join-command` per generare il token per i workers:
```bash
kubeadm token create --print-join-command
```

### Aggiunta di master nodes al cluster
Da un altro nodo, lanciare lo script di output per i nodi master, esempio
```bash
kubeadm join --discovery-token abcdef.1234567890abcdef --discovery-token-ca-cert-hash sha256:1234..cdef --control-plane 1.2.3.4:6443
```

### Inizializzazione dei worker node
Dal worker node, lanciare lo script output dal comando lanciato dal master node, esempio:
! ATTENZIONE ! Questo comando é solo di esempio, non utilizzare questo, ma quello fornito dal comando precedente
```bash
 kubeadm join k8s-master01:6443 --token 69s57o.3muk7ey0j0zknw69 --discovery-token-ca-cert-hash sha256:8000dff8e803e2bf687f3dae80b4bc1376e5bd770e7a752a3c9fa314de6449fe
```

### Impostazione per la modalitá cluster K8S ibrido master+worker
Settare il label per i worker nodes:
```bash
kubectl label node kube-worker-01 node-role.kubernetes.io/worker=control-plane
```

### Installazione di Calico
Il componente aggiuntivo di rete Calico è richiesto sul cluster Kubernetes per abilitare la comunicazione tra i pod, per far funzionare il servizio DNS con il cluster e per rendere lo stato dei nodi come Pronto.
```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
```

### Comandi utili per testare kubernetes:
```bash
kubectl get pods -n kube-system // Verifica lo status dei pod di calico
kubectl get nodes // Ottiene informazioni sui nodi all'interno del cluster
```

### TEST: Installazione di un nginx all'interno del cluster
```bash
kubectl create deployment web-nginx-01 --image nginx --replicas 2
kubectl expose deployment web-nginx-01 --type NodePort --port 80
kubectl get deployment web-nginx-01
kubectl get pods
kubectl get svc web-nginx-01

curl <hostname_worker_node>:31121 // curl verso il worker node sulla porta 31121
```

# Ansible
## Concetti di base di Ansible:
Ansible è un motore di automazione IT open source che automatizza il provisioning, la gestione della configurazione, la distribuzione delle applicazioni, l'orchestrazione e molti altri processi IT.

Ansible è in grado di gestire la configurazione dei sistemi, inclusa l'installazione di pacchetti, la configurazione di file di sistema e la gestione dei servizi di sistema. É in grado di automatizzare il deployment e la gestione di applicazioni su server, integrandosi facilmente tutti gli strumenti descritti precedentemente e tecnologie come sistemi di controllo versione, infrastrutture cloud e containerizzazione.

In questo progetto, Ansible è utilizzato per eseguire una serie di compiti essenziali:
Gestisce l'esecuzione dei comandi Terraform per il deployment delle macchine virtuali nell'ambiente HCloud. Inoltre, si occupa di orchestrare tutte le operazioni necessarie per creare e configurare un cluster Kubernetes completo.

### Proprietá chiave di Ansible e perché abbiamo scelto di utilizzarlo:
1. Agentless architecture: Basso overhead di manutenzione evitando l'installazione di un software aggiuntivo (come per esempio Python o Go) su tutta l'infrastruttura IT.
2. Semplicitá: Al posto di utilizzare dei file bash per effettuare il deploy del cluster k8s, utilizziamo Ansible e i suoi playbook: I playbook di automazione utilizzano una sintassi YAML diretta per il codice che legge come documentazione. Ansible è anche decentralizzato, utilizzando le credenziali OS esistenti tramite SSH per accedere alle macchine remote.
3. Scalabilità e flessibilità: Scala facilmente e rapidamente i sistemi che automatizza attraverso un design modulare, questo ci permette di espandere il cluster aggiungendo nuovi nodi in base al workload e quindi anche rimuovere componenti in base alle esigenze. Questo per ottimizzare risorse ed evitare sprechi.
4. Idempotenza e prevedibilità: Quando il sistema è nello stato descritto dal tuo playbook, Ansible non cambia nulla, anche se il playbook viene eseguito più volte.

### Installazione Ansible
Per una guida completa sull'installazione di ansible riferirsi alla documentazione ufficiale: 

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

## Inizializzazione del playbook
Il playbook YAML di Ansible è un file che contiene le istruzioni e task necessari che Ansible deve eseguire su una destinazione precisa.

### Integrazione Ansible e Terraform

L'integrazione di Ansible e Terraform offre una sinergia potente per l'automazione e la gestione dell'infrastruttura. Esistono diverse modalità per integrare queste due piattaforme, ognuna con i suoi vantaggi e le sue considerazioni.

### Modalità di Integrazione

# Modalità Manuale

La modalità manuale non richiede un'introduzione specifica e può essere implementata facilmente attraverso uno script bash che richiama Terraform seguito da Ansible da riga di comando. Questo approccio offre flessibilità e controllo diretto sull'esecuzione delle operazioni, tuttavia, richiede una gestione accurata delle dipendenze e delle sequenze di esecuzione.

# Utilizzo di Ansible come Provvisionatore in Terraform

Un'altra pratica comune è l'utilizzo di Ansible come provvisionatore in Terraform, trattando i playbook Ansible come parte del processo di provisioning dell'infrastruttura. Tuttavia, sebbene questa pratica possa sembrare intuitiva, è sconsigliata dalla documentazione ufficiale di Terraform. Questo è principalmente dovuto alle complessità nella gestione dello stato dell'infrastruttura, che può portare a problemi di coerenza e di sincronizzazione tra Terraform e Ansible.

Per ulteriori dettagli e considerazioni su questa pratica, si consiglia di consultare la documentazione ufficiale di Terraform:

[Documentazione Terraform sui Provvisionatori](https://www.terraform.io/docs/language/resources/provisioners/syntax)

# Utilizzo di Terraform attraverso Ansible

Integrare Terraform all'interno di un playbook Ansible offre una sinergia potente che combina le capacità di provisioning e gestione dell'infrastruttura di Terraform con la flessibilità e l'automazione di Ansible. Questa architettura presenta diversi vantaggi distintivi rispetto agli approcci tradizionali:

 1. Gestione dei Segreti con Ansible Vault

Uno dei vantaggi principali è la possibilità di gestire in modo sicuro i segreti e le credenziali utilizzando Ansible Vault. Ansible Vault consente di crittografare e proteggere i dati sensibili, come password, chiavi API e token, all'interno dei playbook Ansible. Integrando Terraform all'interno di Ansible, è possibile beneficiare direttamente di questa funzionalità, garantendo la sicurezza e la conformità dei dati sensibili durante l'esecuzione delle operazioni di provisioning e configurazione dell'infrastruttura.

 2. Automazione Integrata nel Playbook

L'integrazione di Terraform nel playbook Ansible consente di automatizzare l'intero processo di provisioning e configurazione dell'infrastruttura all'interno di un'unica sequenza di passaggi. Questo semplifica notevolmente la gestione e l'esecuzione delle operazioni, riducendo la complessità e il rischio di errori manuali. Inoltre, l'automazione integrata consente una maggiore coerenza e ripetibilità nelle operazioni, migliorando l'affidabilità e la scalabilità complessiva dell'ambiente.

 3. Coerenza tra Infrastruttura e Configurazione

Integrando Terraform e Ansible, è possibile garantire una maggiore coerenza tra l'infrastruttura provisionata da Terraform e la configurazione del software gestita da Ansible. Questo approccio favorisce una migliore sincronizzazione e allineamento tra le risorse infrastrutturali e le politiche di configurazione, riducendo il rischio di drift e migliorando la gestione e il controllo dell'ambiente IT nel suo complesso.

 4. Flessibilità nell'Utilizzo di Risorse Estese

L'utilizzo di Terraform all'interno di Ansible offre una maggiore flessibilità nell'uso delle risorse provisionate. Ansible fornisce un'ampia gamma di moduli e playbook predefiniti per la configurazione e la gestione delle risorse, consentendo di estendere facilmente le funzionalità di Terraform attraverso l'aggiunta di nuove azioni e configurazioni specifiche del caso d'uso. Questo permette di adattare e personalizzare l'ambiente infrastrutturale in base alle esigenze specifiche del progetto o dell'organizzazione.

 5. Monitoraggio e Logging Integrati

Integrando Terraform e Ansible, è possibile implementare un sistema completo di monitoraggio e logging per tracciare e analizzare le operazioni di provisioning e configurazione dell'infrastruttura. Ansible offre funzionalità avanzate di logging e reportistica, mentre Terraform consente di integrarsi con una vasta gamma di strumenti di monitoraggio e gestione delle performance. Questo permette di identificare rapidamente eventuali problemi o anomalie nell'ambiente e di adottare misure correttive tempestive.

# Elenco dei playbook di playbook.yaml
## Playbook1: Terraform
Corrisponde all'integrazione all'interno di Terraform, scarica il file del repository HashiCorp per RHEL utilizzando wget e lo visualizza in standard output e utilizza il modulo dnf per installare Terraform sul sistema.
Esegue inoltre il comando terraform --version per controllare la versione di Terraform appena installata e registra l'output.
Utilizza il modulo debug per stampare l'output registrato solo se il comando precedente ha avuto successo.
Terraform init: Esegue terraform init nella directory di lavoro Terraform specificata.
Terraform plan: Esegue terraform plan e crea un file di pianificazione plan nella directory di lavoro Terraform specificata.
Terraform apply: Applica il piano Terraform precedentemente creato utilizzando terraform apply -auto-approve.

## Playbook2: Leggi gli host dall'inventario
Carica il file di inventario YAML inventory.yaml e memorizza i dati in una variabile chiamata inventory_data.
Converte il dizionario di host in una lista di coppie chiave-valore per poter iterare su di essa più facilmente.

## Playbook3: Pinga tutti gli host
Pinga tutti gli host nel gruppo 

# ************* INIZIAMO *************
# Come deployare l'intera architettura

Con il termine `jump-server` si intende il worker-node di ansible, ovvero la macchina dalla quale viene eseguito il playbook.
Si presuppone che ansible siano già stati installati correttamente, in quanto terraform viene installato da ansible.

1. Dal `jump-server` dirigersi verso la directory del ansible:
```bash
cd /ansible
```
2. Creiamo un file vuoto di nome "inventory.yaml":
```bash
touch inventory.yaml
```
3. Eseguiamo il playbook specificando i seguenti valori
```bash
ansible-playbook -i inventory.yaml playbook.yaml  -vvv 
```
In caso di errori relativi alla connessione ssh si può specificare la chiave con
```bash
ansible-playbook -i inventory.yaml playbook.yaml --key-file=~/.ssh/nome_chiave_ssh_privata -vvv  
```

### Distruzione dell'infrastruttura

## Terraform Destroy

Per distruggere l'infrastruttura basterà recarsi in nella directory terraform/ e eseguire il comando "terraform destroy"
