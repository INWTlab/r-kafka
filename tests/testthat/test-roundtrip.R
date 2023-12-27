test_that("Roundtrip", {
    config_producer <- list(
        "bootstrap.servers" = brokers
    )
    config_consumer <- list(
        "bootstrap.servers" = brokers,
        "auto.offset.reset" = "latest",
        "group.id" = paste0("test-consumer-", paste0(sample(letters, 6, TRUE), collapse = ""))
    )

    # start consuming to determine current group offset
    consumer <- Consumer(config_consumer)
    consumer$subscribe(topic)
    consumer$consume(6000)

    producer <- Producer(config_producer)
    producer$produce(topic, "Simple message")

    msg <- consumer$consume(10000)

    expect_equal(msg$payload_data, "Simple message")

    consumer$unsubscribe()
    consumer$close()
})


test_that("Roundtrip with key", {
    config_producer <- list(
        "bootstrap.servers" = brokers
    )
    config_consumer <- list(
        "bootstrap.servers" = brokers,
        "auto.offset.reset" = "latest",
        "group.id" = paste0("test-consumer-", paste0(sample(letters, 6, TRUE), collapse = ""))
    )

    # start consuming to determine current group offset
    consumer <- Consumer(config_consumer)
    consumer$subscribe(topic)
    consumer$consume(6000)

    producer <- Producer(config_producer)
    producer$produce_with_key(topic, "Key", "Simple message")

    msg <- consumer$consume(10000)

    expect_equal(content(msg), "Simple message")
    expect_equal(key(msg), "Key")

    consumer$unsubscribe()
    consumer$close()
})
