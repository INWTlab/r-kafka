#include <librdkafka/rdkafkacpp.h>
#include <Rcpp.h>
#include "utils.hpp"

using namespace Rcpp;

class Producer
{
public:
    Producer(Rcpp::List conf_)
    {
        std::string errstr;

        conf = generate_kafka_config(conf_);

        producer = RdKafka::Producer::create(conf, errstr);

        if (!producer)
        {
            Rcpp::stop("Failed to create Kafka producer: " + errstr);
        }
    }

    void produce(const std::string topic, const std::string message)
    {
        if (!producer)
        {
            Rcpp::stop("Kafka producer is not initialized.");
        }

        RdKafka::ErrorCode err = producer->produce(topic, RdKafka::Topic::PARTITION_UA,
                                                   RdKafka::Producer::RK_MSG_COPY /* Copy payload */,
                                                   /* Value */
                                                   const_cast<char *>(message.data()), message.size(),
                                                   /* Key */
                                                   NULL, 0,
                                                   /* Timestamp (defaults to now) */
                                                   0,
                                                   /* Message headers, if any */
                                                   NULL,
                                                   /* Per-message opaque value passed to
                                                    * delivery report */
                                                   NULL);

        if (err != RdKafka::ERR_NO_ERROR)
        {
            Rcpp::stop("Failed to produce message: " + RdKafka::err2str(err));
        }
    }

    void flush(const int timeout_ms)
    {
        RdKafka::ErrorCode err = producer->flush(timeout_ms);

        if (err != RdKafka::ERR_NO_ERROR)
        {
            Rcpp::stop("Failed to flush: " + RdKafka::err2str(err));
        }
    }

private:
    RdKafka::Conf *conf;
    RdKafka::Producer *producer;
};


RCPP_MODULE(producer_module)
{
    class_<Producer>("Producer")
        .constructor<Rcpp::List>()
        .method("produce", &Producer::produce)
        .method("flush", &Producer::flush);
}