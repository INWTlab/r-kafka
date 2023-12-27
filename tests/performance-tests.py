import string
import random

from confluent_kafka import Consumer, Producer
import time

bootstrap_servers = "xxx"  # replace with bootstrap servers
certificate_path = "xxx"

conf = {
    'bootstrap.servers': bootstrap_servers,
    'security.protocol': "ssl",
    'ssl.ca.location': certificate_path,
    'enable.ssl.certificate.verification': "false",
    'group.id': "kafka-r-client-performance-test"
}

consumer = Consumer(conf)
producer = Producer(conf)
consumer.subscribe(["test-topic"])
msg = consumer.poll(timeout=10)


### experiment ###


def generate_random_string(length):
    chars = string.ascii_letters + string.digits
    return ''.join(random.choice(chars) for _ in range(length))


num_strings = 100000
random_strings = [generate_random_string(256) for _ in range(num_strings)]

start_time = time.time()
measurement_interval = 10
strings_processed = 0
str_processed_over_time = []

while True:
    if not random_strings:
        print("No more strings to process. Exiting loop.")
        break

    random_index = random.randrange(len(random_strings))
    current_string = random_strings[random_index]

    # insert random function here

    strings_processed += 1
    random_strings.pop(random_index)

    elapsed_time = time.time() - start_time
    if elapsed_time >= measurement_interval:
        # insert random function here
        print(f"Strings produced so far at {elapsed_time} seconds: {strings_processed}")
        str_processed_over_time.append(strings_processed)
        strings_processed = 0
        start_time = time.time()

start_time = time.time()
measurement_interval = 10
strings_processed = 0

while True:
    msg = consumer.poll(timeout=1.0)
    print(msg.value())
    strings_processed += 1

    elapsed_time = time.time() - start_time
    if elapsed_time >= measurement_interval:
        print(f"Strings consumed so far at {elapsed_time} seconds: {strings_processed}")
        strings_processed = 0
        start_time = time.time()
