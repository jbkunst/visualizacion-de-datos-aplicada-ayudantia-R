library(tidyverse)

set.seed(123)

df <- tibble(
  x = runif(10000, -1, 1),
  y = runif(10000, -1, 1)
)

df <- df |>
  mutate(
    r = x^2 + y^2,
    ri = r < 1,
    conv = cummean(ri),
    row = row_number()
  )

ggplot(df) +
  geom_line(aes(row, 4 * conv)) +
  geom_hline(yintercept = pi, color = "darkred")
