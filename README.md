# Docker for Reposis
This dockerfile creates a solr server with the mir-config sets installed. 

## Environment Variables
SOLR_HOME = /opt/mir-solr-data/

## Mount point 
-> see SOLR_HOME 
 
If you first mount a new directory you need to set the owner to 8983:8983

##Example Usage:
```
sudo docker run -it -p 8983:8983 -v /home/paschty/solr-docker2:/opt/mir-solr-data/ -e SOLR_HOME=/opt/mir-solr-data/ vzgreposis/ubo-solr:latest
```

## build and deploy
```
sudo docker build --pull --no-cache . -t vzgreposis/ubo-solr:latest
sudo docker push  vzgreposis/ubo-solr:latest
```
