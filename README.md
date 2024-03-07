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

## Avvio di una macchina
Hetzner offre VM, dedicated servers e hosting:

- Cloud Server e Dedicated Root Server: configurazioni diverse come CPU e RAM, SSD e larghezza di banda.

- Dedicated vCPU Server: offre maggiore flessibilitá in quanto si paga solo per le vCPU e RAM utilizzate.

