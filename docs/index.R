## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------------
source(here::here("docs/knitr-setup.R"))
library(tidyverse)
library(flipbookr)


## ----out.width="60%", fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/data-science-explore.svg")


## ----out.width="60%", fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/data-viz.jpg")


## ----out.width="50%", fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/viz-mapping-vars.png")


## ----out.width="50%", fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/viz-mapping-vars.png")


## ----out.width="70%", fig.align='center'------------------------------------------------------------------------------------------------
library(datos)
library(ggplot2)

ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista))


## ----out.width="70%", fig.align='center'------------------------------------------------------------------------------------------------
library(datos)
library(ggplot2)

ggplot(millas) +
  geom_point(aes(cilindrada, autopista))


## ----out.width="70%", fig.align='center'------------------------------------------------------------------------------------------------
library(dplyr)

glimpse(millas)


## ---- include=FALSE---------------------------------------------------------------------------------------------------------------------
ggplot2::theme_set(
  ggplot2::theme_gray(base_size = 7) +
  theme(legend.position = "bottom")
)


## ----millas2, include = FALSE-----------------------------------------------------------------------------------------------------------
ggplot(
  millas, 
  aes(cilindrada, autopista)
  ) +
  geom_point(aes(color = traccion)) +
  geom_smooth() +
  scale_color_viridis_d(option = "magma") +
  facet_wrap(vars(anio)) +
  labs(
    title = "Un hermoso título",
    subtitle = "Un bello y extenso subtítulo",
    caption = "Un texto que nadie mira",
    x = "Cilindrada vehículo cc",
    y = "Rendimiento en autopista km/lts",
    color = "Tipo tracción"
    )


## ---- include=FALSE---------------------------------------------------------------------------------------------------------------------
ggplot2::theme_set(
  ggplot2::theme_minimal(base_size = 7) +
  theme(legend.position = "bottom")
)


## ----vuelos_sample, include = FALSE-----------------------------------------------------------------------------------------------------
vuelos2 <- sample_n(vuelos, 5000)

ggplot(vuelos2, aes(distancia, tiempo_vuelo)) +
  geom_point(alpha = 0.05, color = "gray60") +
  geom_smooth(se = FALSE, color = "darkred") +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(limits = c(0, 650))


## ---- echo=FALSE, out.width="90%"-------------------------------------------------------------------------------------------------------
knitr::include_graphics("images/ggplot_elements2.png")


## ---- include=FALSE---------------------------------------------------------------------------------------------------------------------
storms <- readr::read_csv(here::here("data/storms.csv"))
pollution <- readr::read_csv(here::here("data/pollution.csv"))


## ----out.width='70%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/filter.png")


## ----out.width='80%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/filter_example.png")


## ----filter, include = FALSE------------------------------------------------------------------------------------------------------------
storms |>
  filter(storm %in% c("Alberto", "Ana"))


## ----out.width='70%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/select.png")


## ----out.width='80%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/select_example.png")


## ----select, include = FALSE------------------------------------------------------------------------------------------------------------
storms |>
  select(storm, pressure)


## ----out.width='70%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/arrange.png")


## ----out.width='80%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/arrange_example.png")


## ----arrange, include = FALSE-----------------------------------------------------------------------------------------------------------
storms |>
  arrange(wind)


## ----out.width='70%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/mutate.png")


## ----out.width='80%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/mutate_example.png")


## ----mutate, include = FALSE------------------------------------------------------------------------------------------------------------
storms |> 
  mutate(
    ratio = pressure/wind,
    inverse = 1/ratio
    ) |> 
  mutate(wind = log(wind))


## ----out.width='70%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/summarise.png")


## ----out.width='80%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/summarise_example.png")


## ----summarise, include = FALSE---------------------------------------------------------------------------------------------------------
pollution |>
  summarise(median = median(amount))


## ----out.width='70%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/group_by_summarize.png")


## ----out.width='80%', fig.align='center', echo=FALSE------------------------------------------------------------------------------------
knitr::include_graphics("images/dplyr/group_by_summarize_example.png")


## ----group_by, include = FALSE----------------------------------------------------------------------------------------------------------
pollution |> 
  group_by(city) |>
  summarise(
    mean = mean(amount),
    sum = sum(amount),
    n = n()
  )


## ----group_by_spanish, include = FALSE--------------------------------------------------------------------------------------------------
pollution |> 
  group_by(city) |>
  summarise(
    promedio = mean(amount),
    suma = sum(amount),
    conteo = n()
  )


## ----solucion, include = FALSE----------------------------------------------------------------------------------------------------------
library(tidyverse)

set.seed(123)

df <- tibble(
  x = runif(1000, -1, 1),
  y = runif(1000, -1, 1)
)

df |> 
  mutate(r = x^2 + y^2) |> 
  mutate(r2 = if_else(r > 1, "A", "B")) |> 
  mutate(es_b = if_else(r2 == "B", 1, 0)) |> 
  mutate(conv = cummean(es_b)) |> 
  mutate(fila = row_number()) 


## ----solucion2, include = FALSE---------------------------------------------------------------------------------------------------------
library(tidyverse)

set.seed(123)

df <- tibble(
  x = runif(10000, -1, 1),
  y = runif(10000, -1, 1)
)

df |> 
  mutate(
    r = x^2 + y^2,
    ri = r < 1,
    conv = cummean(ri),
    row = row_number()
    ) |> 
  ggplot() +
  geom_line(aes(row, 4 * conv)) +
  geom_hline(yintercept = pi, color = "darkred") 


## ----solucion3, include = FALSE---------------------------------------------------------------------------------------------------------
library(tidyverse)

set.seed(123)

tibble(
  x = runif(10000, -1, 1),
  y = runif(10000, -1, 1)
) |> 
  mutate(
    r = x^2 + y^2,
    ri = r < 1,
    conv = cummean(ri),
    row = row_number()
  ) |> 
  ggplot() +
  geom_line(aes(row, 4 * conv)) +
  geom_hline(yintercept = pi, color = "darkred") +
  scale_x_continuous(labels = scales::comma_format()) +
  scale_y_continuous(
    sec.axis = sec_axis(trans = ~., breaks = pi, labels = expression(pi))
  )


## ----pipe, include = FALSE, echo=FALSE--------------------------------------------------------------------------------------------------
x <- 34

tan(cos(sqrt(log(x))))

y <- x
y <- log(y)
y <- sqrt(y)
y <- cos(y)
y <- tan(y)
y

x |> 
  log() |> 
  sqrt() |> 
  cos() |> 
  tan()

