# Ansible on Kubernetes

Playbook Ansible creati per configurare un cluster Kubernetes completamente automatizzato con un master e più nodi di lavoro. 
Funzionerà su server fisici, macchine virtuali, aws cloud, google cloud o qualsiasi altro server cloud. Questo è stato testato e verificato sui sistemi operativi Centos 7.3 a 64 bit. 
Inoltre è possibile fare riferimento a questo collegamento per la configurazione manuale

## Swap disabling
Since enabling swap permits greater memory usage for workloads in Kubernetes that cannot be predictably accounted for, it also increases the risk of noisy neighbours and unexpected packing configurations, as the scheduler cannot account for swap memory usage.
