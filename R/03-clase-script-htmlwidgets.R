# plotly ------------------------------------------------------------------
library(ggplot2)
library(plotly)
library(dplyr)

data(iris)

glimpse(iris)

p <- ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(vars(Species))

p

ggplotly(p)


# higcharter --------------------------------------------------------------
library(highcharter)
library(forecast)

data("AirPassengers")

plot(AirPassengers)

hchart(AirPassengers)

hchart(AirPassengers, name = "Serie temporal", color = "red")

modelo <- forecast(auto.arima(AirPassengers))

hchart(modelo)


# DT ----------------------------------------------------------------------
library(DT)
library(rvest)   # descargar datos de paginas web

url <- "https://www.sismologia.cl/sismicidad/catalogo/2022/07/20220721.html"

datos <- read_html(url) |>
  html_table() |>
  dplyr::nth(2) |>
  janitor::clean_names() |>
  tidyr::separate(
    latitud_longitud,
    into = c("latitud", "longitud"),
    sep = " ", convert = TRUE
  )

datos

glimpse(datos)

datatable(datos)

# leaflet -----------------------------------------------------------------
leaflet(datos) %>%
  addTiles() %>%
  addMarkers(
    lng = ~longitud,
    lat = ~latitud,
    popup = ~as.character(magnitud_2),
    label = ~as.character(fecha_local_lugar )
  )

