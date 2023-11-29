#include <librdkafka/rdkafkacpp.h>
#include <Rcpp.h>
#include "utils.hpp"

using namespace Rcpp;

class Consumer
{
public:
    Consumer(Rcpp::List conf_)
    {
        std::string errstr;

        conf = generate_kafka_config(conf_);

        consumer = RdKafka::KafkaConsumer::create(conf, errstr);

        if (!consumer)
        {
            Rcpp::stop("Failed to create Kafka Consumer: " + errstr);
        }
    }

    void subscribe(std::vector<std::string> topics)
    {
        RdKafka::ErrorCode err = consumer->subscribe(topics);

        if (err != RdKafka::ERR_NO_ERROR)
        {
            Rcpp::stop("Failed to subscribe to topics: " + RdKafka::err2str(err));
        }
    }

    void unsubscribe()
    {
        std::vector<std::string> topics;
        consumer->subscription(topics);

        for (const auto &topic : topics)
        {
            Rcpp::Rcout << "Unsubscribing from " << topic << std::endl;
        }
        RdKafka::ErrorCode err = consumer->unsubscribe();

        if (err != RdKafka::ERR_NO_ERROR)
        {
            Rcpp::stop("Failed to unsubscribe: " + RdKafka::err2str(err));
        }
    }

    void commit(bool async = false)
    {
      RdKafka::ErrorCode err;
      Rcpp::Rcout << "committing message" << std::endl;
      if (async) {
         err = consumer->commitAsync();
      }

      else {
         err = consumer->commitSync();
      }

        if (err != RdKafka::ERR_NO_ERROR)
        {
            Rcpp::stop("Failed commit: " + RdKafka::err2str(err));
        }
    }

    void close()
    {
        Rcpp::Rcout << "Closing consumer" << std::endl;
        RdKafka::ErrorCode err = consumer->close();
        if (err != RdKafka::ERR_NO_ERROR)
        {
            Rcpp::stop("Failed to close subscriber: " + RdKafka::err2str(err));
        }
    }

    List consume(const int timeout_ms)
    {
        List result;

        const void *payload;
        size_t payload_size;

        RdKafka::Message *msg = consumer->consume(timeout_ms);

        switch (msg->err())
        {
        case RdKafka::ERR_NO_ERROR:
            payload = msg->payload();
            payload_size = msg->len();

            result["payload_data"] = std::string(static_cast<const char *>(payload), payload_size);
            break;
        case RdKafka::ERR__TIMED_OUT:
            break;
        default:
            result["error"] = msg->errstr();
            Rcpp::Rcout << "Error: " << msg->errstr() << std::endl;
        }

        result.attr("class") = "KafkaMessage";

        return result;
    }

private:
    RdKafka::Conf *conf;
    RdKafka::KafkaConsumer *consumer;
};

RCPP_MODULE(consumer_module)
{
    class_<Consumer>("Consumer")
        .constructor<Rcpp::List>()
        .method("subscribe", &Consumer::subscribe)
        .method("unsubscribe", &Consumer::unsubscribe)
        .method("commit", &Consumer::commit)
        .method("consume", &Consumer::consume)
        .method("close", &Consumer::close);
}
