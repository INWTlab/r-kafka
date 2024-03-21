## Installation

From CRAN (add link once it is published)

```r
# install.packages("kafka") # not there yet
```

From GitHub:

```r
remotes::install_github("inwtlab/r-kafka")
```

From drat for latest (unstable) version (same version as on GitHub main trunk):

```r
options(repos = c(getOption("repos"), INWTLab = "https://inwtlab.github.io/drat/"))
install.packages("kafka")
```

### System Requirements (for compilation of the package)

For official installation instructions, see https://github.com/confluentinc/librdkafka#installation

#### Ubuntu and debian systems

```sh
apt get install librdkafka-dev
```

#### Mac OS X systems

```zsh
brew install librdkafka
```

#### Windows

- Install RTools (i.e. using `installr::install.rtools()`)
- Download the librdkafka binaries and header files using the rtools bash / msys2 command line: `pacman -Sy mingw-w64-ucrt-x86_64-librdkafka`
- Add the path to the msys2 binaries to your windows PATH (settings -> edit environment variables for your account)
- (Potentially) change directory to msys2 in the Makevars.win file if it is not located at `C:/rtools43/ucrt64/`

## Getting started

Produce messages

```r
library("kafka")

config <- list(
    "bootstrap.servers" = "brokers"
)

producer <- Producer$new(config)
producer$produce("my-topic", "Simple message")
producer$flush()
```

Consume messages

```r
library("kafka")

config <- list(
    "bootstrap.servers" = "brokers",
    "auto.offset.reset" = "earliest",
    "group.id" = "my-group-id"
)

consumer <- Consumer$new(config)
consumer$subscribe("my-topic")

result <- consumer$consume(1000)

msg <- result_message(result)

print(msg)

consumer$close()
```


## (Integration) Tests

### Start Local Kafka Cluster

Start cluster:

```sh
docker compose up -d
```

Save configuration in .Renviron

```sh
echo TOPIC="test-topic" > .Renviron
echo BROKERS="localhost:9093" >> .Renviron
```

Create a new topic

```sh
docker exec kafka-server /opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test-topic --partitions 4
```

### Run tests

```sh
Rscript -e "devtools::install(); devtools::test();"
```