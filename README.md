# HetznerK8s

## Descrizione progetto
Creazione di un cluster K8s su Hetzner composto da tre nodi (master, worker). Dovrà essere possibile creare/distruggere l’ambiente al bisogno, quindi si consiglia di utilizzare dei tool di automazione per la configurazione ed il provisioning delle macchine (es: Ansible e Terraform). 

## Perché Hertzner?
I progetti di data center di Hetzner Online sono coordinati e implementati internamente con il minor ricorso all'outsourcing possibile. Unità data center servite da più uplink ridondanti, inclusi 1300 Gbit/s a DE-CIX e collegamenti in fibra ottica a Norimberga e Francoforte. Le strutture di colocation sono situate in tutti i parchi dei data center di Norimberga, Falkenstein (Vogtland) in Germania e Helsinki in Finlandia.[18] Nel 2021 è stato aperto un data center ad Ashburn, in Virginia, che segna il primo server americano di Hetzner

## Componenti
### API Hetzner 
Endpoint principale: https://api.hetzner.cloud/v1
Autenticazione: Hetzner Cloud utilizza autenticazione su token. Per effettuare una richiesta, è necessario mettere nell'header il Bearer <API_TOKEN>.
```bash
 curl -H 'Authorization: Bearer <API_TOKEN>' \

        -H 'Content-Type: application/json' \

        -d '{ "name": "server01", "server_type": "cx21", "location": "nbg1", "image": "ubuntu-22.04"}' \

        -X POST 'https://api.hetzner.cloud/v1/servers'
```

### Cli Hetzner
É possibile utilizzare la cli di Hetzner.

### Installazione
```bash
scoop install hcloud
```

### Gestting started
Visit the Hetzner Cloud Console at console.hetzner.cloud, select your project, and create a new API token.

Configure the hcloud program to use your token:

```bash
hcloud context create my-project
```

You’re ready to use the program. For example, to get a list of available server types, run:

```bash
hcloud server-type list
```

Di seguito alcuni comandi:

 - hcloud server create: Crea un nuovo server virtuale.

 - hcloud server list: Visualizza l'elenco dei server virtuali attualmente presenti nel tuo account.

 - hcloud server delete: Cancella un server virtuale.

 - hcloud volume create: Crea un nuovo volume di archiviazione.

 - hcloud volume list: Visualizza l'elenco dei volumi nel tuo account.

 - hcloud image list: Visualizza l'elenco delle immagini disponibili.

 - hcloud ssh-key create: Crea una nuova chiave SSH da utilizzare per l'accesso ai server.

 - hcloud network list: Visualizza l'elenco delle reti definite nel tuo account.

 - hcloud firewall create: Crea un nuovo firewall per controllare il traffico di rete.

 - hcloud floating-ip create: Crea un nuovo indirizzo IP fluttuante.

### Hetzner Cloud Controller Manager

https://github.com/hetznercloud/hcloud-cloud-controller-manager

Il cloud-controller-manager di Hetzner integra il cluster Kubernetes con le API Hetzner Cloud & Robot.

Vantaggio principale: maggiore automazione e integrazione Kubernetes/Hetzner Cloud

- Consistenza nell'orchestrazione delle risorse: compatibilitá con Kubernetes per la gestione delle risorse Hetzner all'interno del cluster Kubernetes.

- Facilità nell'implementazione di nuovi nodi: Rende la gestione per l'aggiunta di nuovi nodi al cluster Kubernetes molto semplificata. É possibile scalare orizzontalmente senza gestire l'infrastruttura sottostante.

### CSI-Driver (Container Storage Interface)

[https://github.com/hetznercloud/csi-driver]

Utilizzato per la creazione di volumi persistenti per l'archiviazione e gestione dello storage all'interno dei container.
Semplifica l'allocazione, il montaggio e la gestione dello storage necessario per le applicazioni containerizzate.

Vantaggi:
 - Provisioning dinamico: I driver CSI consentono la creazione dinamica di volumi di archiviazione in base alle esigenze delle applicazioni.

 - Gestione semplificata: Facilitano la gestione dello storage all'interno di un cluster Kubernetes, offrendo un'interfaccia comune.

 - Portabilità: L'utilizzo di uno standard come CSI rende più semplice spostare applicazioni e carichi di lavoro tra cluster Kubernetes che utilizzano diversi fornitori di storage.

## VM Hetzner
Hetzner offre VM, dedicated servers e hosting:

- Cloud Server e Dedicated Root Server: configurazioni diverse come CPU e RAM, SSD e larghezza di banda.

- Dedicated vCPU Server: offre maggiore flessibilitá in quanto si paga solo per le vCPU e RAM utilizzate.

L'uso di vCPU dedicate é l'ideale per un cluster kubernetes per ottimizzare le prestazioni del cluster in base alle esigenze specifiche. É possibile dimensionare le risorse in base alle necessitá sfruttando il pay as you go. 

# Getting started

- Creazione del progetto in Hetzner

- Selezione della vm

- Creazione chiavi SSH

- Creazione API TOKEN

- Creazione della folder terraform

- kubespray.io

- Infrastructure Setup con Terraform
```terraform
provider "hcloud" {
 token="${var.HCLOUD_API_TOKEN"
}
```

```terraform
terraform {
 required_providers {
  hcloud = {
   source = "hetznercloud/hcloud"
  }
}
required _version = ">=0.14"
}
```

- Kubernetes Cluster Deployment with Kubespray

- Verifying the Cluster

- Load Balancer Setup

- Conclusion
