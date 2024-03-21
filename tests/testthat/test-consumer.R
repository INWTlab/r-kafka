test_that("Teardown consumer with subscription", {
    config_consumer <- list(
        "bootstrap.servers" = brokers,
        "auto.offset.reset" = "earliest",
        "group.id" = paste0("test-consumer-", paste0(sample(letters, 6, TRUE), collapse = ""))
    )

    consumer <- Consumer$new(config_consumer)
    consumer$subscribe(topic)

    msg <- consumer$consume(1000)

    expect_output(consumer$unsubscribe(), sprintf("Unsubscribing from %s", topic))
    expect_output(consumer$close(), "Closing consumer")
})