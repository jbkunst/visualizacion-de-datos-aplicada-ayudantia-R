library(tidyverse)

data <- as_tibble(data.table::fread("data/movilidad.gz"))

glimpse(data)


dam <- data |>
  filter(hm("5:00") < hora, hora <= hm("7:00")) |>
  distinct(device_id, .keep_all = TRUE)


dpm <- data |>
  filter(hm("12:00") < hora, hora <= hm("16:00")) |>
  distinct(device_id, .keep_all = TRUE)


d <- inner_join(dam, dpm, by = "device_id", suffix = c("_am", "_pm"))

glimpse(d)

d |>
  count(comuna_am, comuna_pm) |>
  ggplot() +
  geom_tile(aes(comuna_am, comuna_pm, fill = n))
