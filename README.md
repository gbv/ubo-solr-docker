# Docker for Reposis
This dockerfile creates a solr server with the mir-config sets installed. 

## Mount point 
/var/solr/data - the solr data

##Example Usage:
```
sudo docker run -it -p 8983:8983 -v /home/paschty/solr-docker2:/var/solr/data vzgreposis/ubo-solr:latest
```

## build and deploy
```
sudo docker build --pull --no-cache . -t vzgreposis/ubo-solr:latest
sudo docker push  vzgreposis/ubo-solr:latest
```
