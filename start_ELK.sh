# start elasticsearch
docker run -d -p 9200:9200 -h elasticsearch --name elasticsearch elasticsearch
# start kibana, link to elasticsearch
docker run -d -p 5601:5601 -h kibana --name kibana --link elasticsearch:elasticsearch kibana
# start logstash



