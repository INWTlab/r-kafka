test_that("Teardown producer", {
    config_producer <- list(
        "bootstrap.servers" = brokers
    )

    expect_error(Producer(config_producer), NA)
})

