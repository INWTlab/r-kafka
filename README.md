## Installation

From CRAN (add link once it is published)

```r
# install.packages("rkafka") # not there yet
```

From GitHub:

```r
remotes::install_github("inwtlab/r-kafka-client")
```

From drat for latest (unstable) version (same version as on GitHub main trunk):

```r
options(repos = c(getOption("repos"), INWTLab = "https://inwtlab.github.io/drat/"))
install.packages("rkafka")
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

## (Integration) Tests

We are using trivup to spin up a local kafka cluster for testing

## Start Kafka Cluster

Install trivup locally

```
pip install trivup
```

Start Kafka Cluster locally:

```
# create cluster and enter shell
python3 -m trivup.clusters.KafkaCluster --version 3.1.0

# create topic named $TOPIC
TOPIC=my-test-topic

$KAFKA_PATH/bin/kafka-topics.sh --bootstrap-server $BROKERS \
  --create --topic $TOPIC --partitions 4 --replication-factor 3

# persist broker address to be accessible from R
echo BROKERS=$BROKERS > .Renviron
echo TOPIC=$TOPIC >> .Renviron
```

Open R in a new Terminal or reload .Renviron file using `readRenviron(".Renviron")`. Execute tests
using `devtools::test()`

After you are done you can stop the kafka cluster in the first shell by exiting from it:

```
# exit shell, teardown
exit
```
