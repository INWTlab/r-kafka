test_that("Committing throws no error", {
  config_producer <- list(
    "bootstrap.servers" = brokers
  )
  config_consumer <- list(
    "bootstrap.servers" = brokers,
    "auto.offset.reset" = "latest",
    "enable.auto.commit" = "false",
    "group.id" = paste0("test-consumer-", paste0(sample(letters, 6, TRUE), collapse = ""))
  )

  consumer <- Consumer(config_consumer)
  consumer$subscribe(topic)
  consumer$consume(6000)

  producer <- Producer(config_producer)
  producer$produce(topic, "Hello")
  producer$flush(10000)

  msg <- consumer$consume(10000)
  consumer$commit(async = FALSE)

  consumer$unsubscribe()
  consumer$close()

  expect_false(has_error(msg))
})
