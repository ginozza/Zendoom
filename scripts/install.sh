#!/bin/bash

apt-get update
apt-get install -y iptables net-tools less

chmod +x scripts/zendoom.sh
chmod +x scripts/start.sh

echo "Instalación completa. Puedes iniciar el script con 'scripts/start.sh'."
