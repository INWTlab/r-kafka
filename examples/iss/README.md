## Run it

```
docker compose up -d
docker compose exec kafka /usr/bin/kafka-topics --bootstrap-server localhost:9092 --create --topic iss --partitions 2
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