#include <librdkafka/rdkafkacpp.h>
#include <Rcpp.h>
#include "utils.h"

using namespace Rcpp;

class PersistentDeliveryReportCb : public RdKafka::DeliveryReportCb
{
public:
    PersistentDeliveryReportCb(const bool verbose)
    {
        verbose_flag = verbose;
    }

    void dr_cb(RdKafka::Message &message)
    {
        switch (message.status())
        {
        case RdKafka::Message::MSG_STATUS_NOT_PERSISTED:
            status_name = "NotPersisted";
            ++count_not_persisted;
            break;
        case RdKafka::Message::MSG_STATUS_POSSIBLY_PERSISTED:
            status_name = "PossiblyPersisted";
            ++count_persisted;
            break;
        case RdKafka::Message::MSG_STATUS_PERSISTED:
            status_name = "Persisted";
            ++count_persisted;
            break;
        default:
            status_name = "Unknown";
            ++count_unknown;
            break;
        }
        if (verbose_flag)
        {
            std::cout << "Message delivery for (" << message.len()
                      << " bytes): " << status_name << ": " << message.errstr()
                      << std::endl;
            if (message.key())
                std::cout << "Key: " << *(message.key()) << ";" << std::endl;
        }
    }

    std::string status_name;
    bool verbose_flag = TRUE;
    int count_persisted = 0;
    int count_not_persisted = 0;
    int count_unknown = 0;
};

class Producer
{
public:
    Producer(Rcpp::List conf_)
    {
        std::string errstr;

        conf = generate_kafka_config(conf_);

        conf->set("dr_cb", &dr_cb, errstr);

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
            Rcpp::stop("Kafka producer is not running.");
        }

        RdKafka::ErrorCode err = producer->produce(
            topic, RdKafka::Topic::PARTITION_UA,
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
        if (!producer)
        {
            Rcpp::stop("Kafka producer is not running.");
        }

        RdKafka::ErrorCode err = producer->flush(timeout_ms);

        if (err != RdKafka::ERR_NO_ERROR)
        {
            Rcpp::stop("Failed to flush: " + RdKafka::err2str(err));
        }
    }

    void close()
    {
        // Following
        // https://github.com/confluentinc/librdkafka/blob/master/INTRODUCTION.md#producer
        // and https://github.com/confluentinc/librdkafka/issues/1499
        if (!producer)
        {
            Rcpp::stop("Kafka producer is not running.");
        }

        producer->flush(60 * 1000);
        delete producer;
    }

    void fatal_error()
    {
        if (!producer)
        {
            Rcpp::stop("Kafka producer is not running.");
        }

        std::string errstr;
        RdKafka::ErrorCode err = producer->fatal_error(errstr);
        if (err != RdKafka::ERR_NO_ERROR)
        {
            Rcpp::stop("Fatal error: " + errstr);
        }
    }

    int poll()
    {
        if (!producer)
        {
            Rcpp::stop("Kafka producer is not running.");
        }

        return producer->poll(0);
    }

    Rcpp::List delivered_messages()
    {
        poll();
        return Rcpp::List::create(
            Named("count_persisted") = dr_cb.count_persisted,
            Named("count_unknown") = dr_cb.count_unknown,
            Named("count_not_persisted") = dr_cb.count_not_persisted);
    }

    int status(const std::string topic)
    {
        if (!producer)
        {
            Rcpp::stop("Kafka producer is not running.");
        }

        dr_cb.status_name = "Unknown";
        produce(topic, "");
        producer->poll(60 * 1000);
        producer->flush(5 * 1000);

        if (dr_cb.status_name == "Persisted")
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }

private:
    PersistentDeliveryReportCb dr_cb = PersistentDeliveryReportCb(TRUE);
    RdKafka::Conf *conf;
    RdKafka::Producer *producer;
};

RCPP_MODULE(producer_module)
{
    class_<Producer>("Producer")
        .constructor<Rcpp::List>()
        .method("produce", &Producer::produce)
        .method("flush", &Producer::flush)
        .method("close", &Producer::close)
        .method("fatal_error", &Producer::fatal_error)
        .method("poll", &Producer::poll)
        .method("status", &Producer::status)
        .method("delivered_messages", &Producer::delivered_messages);
}
