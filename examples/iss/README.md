## Run it

```
docker compose up -d
docker exec kafka-server /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic iss --partitions 2
```

Install Package
```
Rscript -e 'remotes::install_github("inwtlab/r-kafka")'
```

Run Producer
```
Rscript examples/iss/producer.R
```

Run App
```
Rscript -e 'shiny::runApp("examples/iss")'
```