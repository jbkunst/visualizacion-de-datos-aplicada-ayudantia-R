# usethis::use_git_ignore("data-raw")
library(tidyverse)

datos <- as_tibble(data.table::fread("data-raw/01.csv/01.csv"))

glimpse(datos)

datos <- rename_with(datos, str_to_lower)

glimpse(datos)

datos |>
  count(is.na(timestamp))

datos <- datos |>
  mutate(fecha_hora = as_datetime(timestamp/1000))

ggplot(datos) +
  geom_histogram(aes(fecha_hora))

datos |>
  count(id_type)

datos |>
  count(device_os)

datos |>
  count(device_os, device_os_version)

datos_100mil <- sample_n(datos, 10000)
# datos_100mil <- datos

ggplot(datos_100mil) +
  geom_point(aes(longitude, latitude))


# mapa --------------------------------------------------------------------
library(sf)
library(chilemapas)

datos_100mil <-  st_as_sf(datos_100mil, coords = c("longitude","latitude"), remove = FALSE)

rm <- filter(mapa_comunas, codigo_region == 13) |>
  left_join(codigos_territoriales |> select(matches("comuna")))

rm <- st_as_sf(rm)

st_crs(datos_100mil) <- st_crs(rm)

datos_100mil <- st_intersection(datos_100mil, rm)

plot(datos_100mil)

datos_100mil <- as_tibble(datos_100mil)

ggplot(datos_100mil) +
  geom_point(aes(longitude, latitude))

ggplot(rm) +
  geom_sf(aes(geometry = geometry)) +
  # geom_sf_text(aes(label = nombre_comuna, geometry = geometry)) +
  geom_point(
    aes(longitude, latitude),
    data = datos_100mil,
    alpha = 0.5)

ggplot(rm) +
  geom_sf(aes(geometry = geometry)) +
  # geom_sf_text(aes(label = nombre_comuna, geometry = geometry)) +
  geom_density_2d_filled(
    aes(longitude, latitude),
    data = datos_100mil,
    alpha = 0.5)

glimpse(datos_100mil)


ggplot(rm) +
  geom_sf(aes(geometry = geometry)) +
  # geom_sf_text(aes(label = nombre_comuna, geometry = geometry)) +
  geom_density_2d_filled(
    aes(longitude, latitude),
    data = datos_100mil,
    alpha = 0.5) +
  facet_wrap(vars(santoku::chop_deciles(fecha_hora)))


# gran santiago -----------------------------------------------------------

library(sf)
library(tidyverse)

url_gs_geojson <- "https://raw.githubusercontent.com/robsalasco/precenso_2016_geojson_chile/87bc72ea23ad19a116ae9af02fa1cb5ae06f29f3/Extras/GRAN_SANTIAGO.geojson"



geo <- sf::st_read(url_gs_geojson)

plot(geo)

geo <- as_tibble(geo)
geo <- st_as_sf(geo)

geo

plot(geo)


ggplot(geo) +
  geom_sf(aes(geometry = geometry, fill =  as.numeric(COMUNA)))



