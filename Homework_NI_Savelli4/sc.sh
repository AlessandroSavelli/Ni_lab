for r in r5 r6 r7 r8; do
    mkdir -p $r/etc/quagga
    
    # Abilita zebra (gestore kernel) e ospfd (protocollo OSPF)
    echo "zebra=yes" > $r/etc/quagga/daemons
    echo "ospfd=yes" >> $r/etc/quagga/daemons
    
    # Configurazione base di Zebra
    echo "hostname $r" > $r/etc/quagga/zebra.conf
    echo "password zebra" >> $r/etc/quagga/zebra.conf
    echo "log file /var/log/quagga/zebra.log" >> $r/etc/quagga/zebra.conf
done
