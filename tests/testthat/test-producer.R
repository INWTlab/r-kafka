test_that("Teardown producer", {
    config_producer <- list(
        "bootstrap.servers" = brokers
    )

    expect_error(Producer$new(config_producer), NA)
})

