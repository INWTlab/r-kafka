#include <librdkafka/rdkafkacpp.h>
#include <Rcpp.h>

using namespace Rcpp;

#ifndef __UTILITIES__
#define __UTILITIES__

inline RdKafka::Conf* generate_kafka_config(Rcpp::List conf_, bool verbose = false) {
    RdKafka::Conf *conf;
    std::string errstr;

    conf = RdKafka::Conf::create(RdKafka::Conf::CONF_GLOBAL);

    Rcpp::CharacterVector keys = conf_.names();

    for (int i = 0; i < conf_.size(); i++)
    {
        std::string key = Rcpp::as<std::string>(keys[i]);
        std::string value = Rcpp::as<std::string>(conf_[i]);

        if (conf->set(key, value, errstr) != RdKafka::Conf::CONF_OK)
        {
            Rcpp::warning(errstr);
        }
        else if (verbose)
        {   
            // Do not print configuration values as they may contain credentials.
            Rcpp::Rcout << "Configuration property set: " << key << std::endl;
        }
    }

    return conf;
};

#endif // __UTILITIES__
