from confluent_kafka import Consumer, Producer


bootstrap_servers = "bootstrap_servers"  # replace with bootstrap servers

conf = {
    'bootstrap.servers': bootstrap_servers,
    'security.protocol': "ssl",
    'group.id': "kafka-r-client-performance-test"
}

consumer = Consumer(conf)
producer = Producer(conf)
consumer.subscribe(["hackathon-test-topic"])

while True:
    msg = consumer.poll(timeout=1.0)
    if msg is None:
        print("xxx")
        continue
    record_value = msg.value()
    print(record_value)

producer.produce("hackathon-test-topic", key="test-michelle", value="xxx")
producer.flush()

################################################################
# code to create topics - not needed for the performance tests #

from confluent_kafka.admin import AdminClient, NewTopic

admin_client = AdminClient({
    "bootstrap.servers": bootstrap_servers,
    'security.protocol': "ssl",
    'ssl.ca.location': "/etc/ssl/certs/ca-certificates.crt"
})

topic_list = [NewTopic("hackathon-test-topic", 1, 1)]
admin_client.create_topics(topic_list)

producer.list_topics()
topic_metadata = producer.list_topics()
topic_metadata.topics.get("hackathon-test-topic")
