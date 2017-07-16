docker run -v "$PWD/pcaps":/pcaps -v "$PWD/logs_tmp":/logs bro_nsm /bin/bash pcaps_to_logs.sh
python adjust_dates.py -i logs_tmp/ -o logs -hr 10
docker run -h logstash --name logstash --link elasticsearch:elasticsearch -it --rm -v "$PWD/config/logstash":/config-dir -v "$PWD/logs":/usr/share/logstash/logs logstash -f /config-dir/logstash.conf -l /usr/share/logstash/logs

