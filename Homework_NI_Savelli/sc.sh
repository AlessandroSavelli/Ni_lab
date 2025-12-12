#!/bin/bash

# Funzione per creare la directory e iniziare il file
setup_node() {
    local node=$1
    mkdir -p "$node/etc/network"
    echo "auto lo" > "$node/etc/network/interfaces"
    echo "iface lo inet loopback" >> "$node/etc/network/interfaces"
    echo "" >> "$node/etc/network/interfaces"
    echo "Configurazione $node..."
}

# Funzione per aggiungere un'interfaccia
add_iface() {
    local node=$1
    local iface=$2
    local ip=$3
    local gw=$4

    echo "auto $iface" >> "$node/etc/network/interfaces"
    echo "iface $iface inet static" >> "$node/etc/network/interfaces"
    echo "	address $ip" >> "$node/etc/network/interfaces"
    if [ ! -z "$gw" ]; then
        echo "	gateway $gw" >> "$node/etc/network/interfaces"
    fi
    echo "" >> "$node/etc/network/interfaces"
}

echo "--- Inizio generazione file interfaces ---"

# --- ROUTER 1 ---
setup_node "r1"
add_iface "r1" "eth0" "192.168.1.1/24"      # LAN
add_iface "r1" "eth1" "50.0.0.0/31"         # vs r2 (Basso)
add_iface "r1" "eth2" "50.0.0.2/31"         # vs r3 (Basso)
add_iface "r1" "eth3" "50.0.0.8/31"         # vs r4 (Basso - CORRETTO)

# --- ROUTER 2 ---
setup_node "r2"
add_iface "r2" "eth0" "50.0.0.1/31"         # vs r1 (Alto)
add_iface "r2" "eth1" "50.0.0.4/31"         # vs r4 (Basso)

# --- ROUTER 3 ---
setup_node "r3"
add_iface "r3" "eth0" "50.0.0.3/31"         # vs r1 (Alto)
add_iface "r3" "eth1" "50.0.0.6/31"         # vs r4 (Basso)

# --- ROUTER 4 ---
setup_node "r4"
add_iface "r4" "eth0" "50.0.0.5/31"         # vs r2 (Alto)
add_iface "r4" "eth1" "50.0.0.7/31"         # vs r3 (Alto)
add_iface "r4" "eth2" "50.0.0.9/31"         # vs r1 (Alto - CORRETTO)
add_iface "r4" "eth3" "193.201.28.1/23"     # vs r5 (Basso)

# --- ROUTER 5 ---
setup_node "r5"
add_iface "r5" "eth0" "193.201.29.254/23"   # vs r4 (Alto)
add_iface "r5" "eth1" "100.0.0.6/31"        # vs r6 (Basso)
add_iface "r5" "eth2" "100.0.0.0/31"        # vs r7 (Basso)
add_iface "r5" "eth3" "100.0.0.8/31"        # vs r8 (Basso)

# --- ROUTER 6 ---
setup_node "r6"
add_iface "r6" "eth0" "100.0.0.7/31"        # vs r5 (Alto)
add_iface "r6" "eth1" "100.0.0.4/31"        # vs r7 (Basso)
add_iface "r6" "eth2" "100.0.0.2/31"        # vs r8 (Basso)
add_iface "r6" "eth3" "23.75.0.1/16"        # vs Server 1 (Gateway)

# --- ROUTER 7 ---
setup_node "r7"
add_iface "r7" "eth0" "100.0.0.1/31"        # vs r5 (Alto)
add_iface "r7" "eth1" "100.0.0.5/31"        # vs r6 (Alto)
add_iface "r7" "eth2" "100.0.0.10/31"       # vs r8 (Basso)
add_iface "r7" "eth3" "151.0.45.0/31"       # vs r10 (Basso)

# --- ROUTER 8 ---
setup_node "r8"
add_iface "r8" "eth0" "100.0.0.9/31"        # vs r5 (Alto)
add_iface "r8" "eth1" "100.0.0.3/31"        # vs r6 (Alto)
add_iface "r8" "eth2" "100.0.0.11/31"       # vs r7 (Alto)
add_iface "r8" "eth3" "145.97.4.97/27"      # vs r9 (Basso)

# --- ROUTER 9 ---
setup_node "r9"
add_iface "r9" "eth0" "145.97.4.126/27"     # vs r8 (Alto)
add_iface "r9" "eth1" "192.168.1.1/24"      # LAN (Gateway)

# --- ROUTER 10 ---
setup_node "r10"
add_iface "r10" "eth0" "151.0.45.1/31"      # vs r7 (Alto)
add_iface "r10" "eth1" "192.168.88.1/24"    # LAN (Gateway)

# --- PC e SERVER (Includono il Gateway) ---

# PC1 (LAN r1)
setup_node "pc1"
add_iface "pc1" "eth0" "192.168.1.10/24" "192.168.1.1"

# PC2 (LAN r9)
setup_node "pc2"
add_iface "pc2" "eth0" "192.168.1.10/24" "192.168.1.1"

# PC3 (LAN r10)
setup_node "pc3"
add_iface "pc3" "eth0" "192.168.88.150/24" "192.168.88.1"

# SERVER 1 (LAN r6)
setup_node "s1"
add_iface "s1" "eth0" "23.75.0.10/16" "23.75.0.1"

# SERVER 2 (LAN r9)
setup_node "s2"
add_iface "s2" "eth0" "192.168.1.20/24" "192.168.1.1"

# SERVER 3 (LAN r10)
setup_node "s3"
add_iface "s3" "eth0" "192.168.88.100/24" "192.168.88.1"

echo "--- Completato! Tutti i file interfaces sono stati creati. ---"
