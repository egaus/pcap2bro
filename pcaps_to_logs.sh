rm /logs/*.log
/opt/bro/bin/bro -r /pcaps/*.pcap /opt/bro/share/bro/site/local.bro
mv ./*.log /logs

