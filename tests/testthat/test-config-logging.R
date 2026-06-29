test_that("Kafka config values are not printed by default", {
  secret <- "super-secret-password-should-not-be-logged"
  
  config_producer <- list(
    "bootstrap.servers" = brokers,
    "sasl.username" = "test-user",
    "sasl.password" = secret
  )
  
  output <- capture.output({
    producer <- Producer$new(config_producer)
  })
  
  expect_false(any(grepl(secret, output, fixed = TRUE)))
})
