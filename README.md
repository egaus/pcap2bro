Convert PCAPs to Searchable Logs in ELK
=======================================

The main goals of this project are to:
* Provide a quick way to convert a pcap to bro logs
* Ingest the bro logs into a dockerized ELK environment

----

Prerequisites
------------
Need docker installed and this was all built and tested on an Ubuntu machine.

Usage Examples
--------------
1) Run ELK
``./run_ELK.sh``

2) Generate bro logs in json format:
``docker run -v "$PWD/pcaps":/pcaps -v "$PWD/logs":/logs bro_nsm /bin/bash pcaps_to_logs.sh``

3) Run logstash with locally mounted directory of logs
``docker run -h logstash --name logstash --link elasticsearch:elasticsearch -it --rm -v "$PWD/config/logstash":/config-dir -v "$PWD/logs":/usr/share/logstash/logs logstash -f /config-dir/logstash.conf -l /usr/share/logstash/logs``


