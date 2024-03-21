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
    consumer <- Consumer$new(config_consumer)
    consumer$subscribe(topic)
    consumer$consume(6000)

    producer <- Producer$new(config_producer)
    producer$produce(topic, "Simple message")

    result <- consumer$consume(10000)
    message <- result_message(result)

    expect_equal(message$value, "Simple message")
    expect_true(is.null(message$key))
    expect_equal(result_has_error(result), FALSE)
    expect_equal(result_error_message(result), NULL)
    expect_equal(result_error_code(result), NULL)

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
    consumer <- Consumer$new(config_consumer)
    consumer$subscribe(topic)
    consumer$consume(6000)

    producer <- Producer$new(config_producer)
    producer$produce(topic, key = "Key", "Simple message")

    result <- consumer$consume(10000)
    message <- result_message(result)

    expect_equal(message$value, "Simple message")
    expect_equal(message$key, "Key")
    expect_equal(result_has_error(result), FALSE)
    expect_equal(result_error_message(result), NULL)
    expect_equal(result_error_code(result), NULL)

    consumer$unsubscribe()
    consumer$close()
})
