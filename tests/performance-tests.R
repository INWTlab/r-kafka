## setup ----------------------------------------------------------------------
library(tictoc)
devtools::load_all()

bootstrap_servers = "xxx"
certificate_path = "xxx"

config <- list(
  bootstrap.servers = bootstrap_servers,
  security.protocol="SSL",
  ssl.ca.location = certificate_path,
  enable.ssl.certificate.verification = "false",
  group.id = "test"
)

producer <- Producer(config)
consumer <- Consumer(config)
consumer$subscribe("test-topic")
consumer$consume(10000)

## Experiment ------------------------------------------------

generate_random_string <- function(length) {
  chars <- c(letters, LETTERS, 0:9)
  paste0(sample(chars, length, replace = TRUE), collapse = "")
}

num_strings <- 100000  # Adjust the number of strings as needed
random_strings <- replicate(num_strings, generate_random_string(256))

start_time <- Sys.time()
measurement_interval <- 10
strings_processed <- 0
str_processed_over_time <- list()

while (TRUE) {
  if (length(random_strings) == 0) {
    cat("No more strings to process. Exiting loop.\n")
    break
  }
  random_index <- sample(seq_along(random_strings), 1)
  current_string <- random_strings[random_index]
  
  producer$produce("test-topic", current_string)
  
  strings_processed <- strings_processed + 1
  random_strings <- random_strings[-random_index]

  elapsed_time <- difftime(Sys.time(), start_time, units = "secs")
  if (elapsed_time >= measurement_interval) {
    producer$flush(1000)
    cat("Strings produced so far at", elapsed_time, "seconds:", strings_processed, "\n")
    str_processed_over_time <- append(str_processed_over_time, strings_processed)
    strings_processed <- 0
    start_time <- Sys.time()
  }
}

start_time <- Sys.time()
measurement_interval <- 10
strings_processed <- 0

while (TRUE) {
  consumed_string <- consumer$consume(1000)
  # print(content(consumed_string))
  strings_processed <- strings_processed + 1
  
  elapsed_time <- difftime(Sys.time(), start_time, units = "secs")
  if (elapsed_time >= measurement_interval) {
    cat("Strings consumed so far at", elapsed_time, "seconds:", strings_processed, "\n")
    strings_processed <- 0
    start_time <- Sys.time()
  }
}


##### Plot ---------------------------------------------------------------------


library(ggplot2)
time_points <- seq(0, by = 10, length.out = length(str_processed_over_time))
values_python <- list() # Insert
data <- data.frame(Time = time_points, Values = unlist(str_processed_over_time))
data <- data.frame(Time = time_points, Values1 = str_processed_over_time, Values2 = values_python)


ggplot(data, aes(x = Time, y = Values)) +
  geom_line(color = "blue") +
  labs(x = "Time (seconds)", y = "Measurement Values", title = "Line Chart of Measurements")

ggplot(data, aes(x = Time)) +
  geom_line(aes(y = Values1, color = "Line 1", linetype = "Line 1"), size = 1) +
  geom_line(aes(y = Values2, color = "Line 2", linetype = "Line 2"), size = 1) +
  labs(x = "Time (seconds)", y = "Measurement Values", title = "Line Chart of Measurements") +
  scale_color_manual(values = c("Line 1" = "blue", "Line 2" = "red")) +
  scale_linetype_manual(values = c("Line 1" = "solid", "Line 2" = "dashed"))

#### tmp: may be removed?
trials <- list(c(1, 10000), c(10000, 20000), c(20000, 30000), c(30000, 40000), c(40000, 50000))

while(TRUE){
  for (trial in trials){
    data <- paste0("test-msg", trial[1]:trial[2])
    tic()
    sapply(data, function(x) producer$produce("test-topic", x))
    toc()
    Sys.sleep(1)
  }
}
producer$flush(1000)
tic()
for(i in 1:rounds){
  consumer$consume(1000)
}
cs_time = toc()

# To Do: Plots
