# datos
storms <- readr::read_csv(here::here("data/storms.csv"))
pollution <- readr::read_csv(here::here("data/pollution.csv"))


# filter
storms |>
  filter(storm %in% c("Alberto", "Ana"))


# select
storms |>
  select(storm, pressure)

# arrange
storms |>
  arrange(wind)


# mutate
storms |>
  mutate(
    ratio = pressure/wind,
    inverse = 1/ratio
  ) |>
  mutate(wind = log(wind))


# summarise
pollution |>
  summarise(median = median(amount))

# group_by
pollution |>
  group_by(city) |>
  summarise(
    mean = mean(amount),
    sum = sum(amount),
    n = n()
  )

# group_by_spanish
pollution |>
  group_by(city) |>
  summarise(
    promedio = mean(amount),
    suma = sum(amount),
    conteo = n()
  )
