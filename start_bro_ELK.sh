# start elasticsearch
docker run -d -p 9200:9200 -p 9300:9300 -it -h bro_elasticsearch --name bro_elasticsearch elasticsearch
# start kibana, link to elasticsearch
docker run -d -p 5601:5601 -h bro_kibana --name bro_kibana --link bro_elasticsearch:elasticsearch kibana
# start logstash



