create_message <- function(payload_data = NULL, error = NULL) {
  msg <- list()
  if (!is.null(payload_data)) {
    msg$payload_data <- payload_data
  }
  class(msg) <- "KafkaMessage"
  msg
}

test_that("Check if message is empty", {
  empty_msg <- create_message()
  not_empty_msg <- create_message(payload_data = "Some message")

  expect_true(is_empty(empty_msg))
  expect_false(is_empty(not_empty_msg))
})

test_that("Get content of message", {
  msg <- create_message(payload_data = "A message")
  empty_msg <- create_message()

  expect_equal(content(msg), "A message")
  expect_true(is.null(content(empty_msg)))
})