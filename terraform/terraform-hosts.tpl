[machines]
%{ for server in servers ~}
${server.name} ansible_host=${server.ipv4_address}
%{ endfor ~}
