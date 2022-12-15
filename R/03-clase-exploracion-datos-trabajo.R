library(tidyverse) # dplyr, ggplot2, y amigos
library(lubridate)

# recuerde el script `R/00-instalar-dependencias.R` !!!!

# esto lo hago para cambiar el tema por defecto de ggplot
theme_set(theme_minimal())

# Más ejemplos en
# 1. https://ggplot2-book.org/polishing.html
# 2. https://github.com/Mikata-Project/ggthemr2
#
# qplot(rnorm(1000))
# qplot(rnorm(1000)) + theme_gray()


# datos -------------------------------------------------------------------
# lectura
# local
datos <- as_tibble(data.table::fread("data/movilidad.gz"))

# desde el repo, más lento
# datos <- as_tibble(data.table::fread("https://github.com/jbkunst/visualizacion-de-datos-aplicada-ayudantia-R/raw/main/data/movilidad.gz"))

glimpse(datos)

# transformaciones inciales
datos <- datos |>
  mutate(
    fecha = as_date(as_datetime(timestamp/1000)),
    hora = hms::as_hms(as_datetime(timestamp/1000)),
    fecha_hora = as_datetime(timestamp/1000),
    .before = timestamp
    )

glimpse(datos)


# que periodos de tiempo posee los datos? ---------------------------------
datos |>
  summarise(
    min(fecha), max(fecha)
  )


# tipo de dispositivo -----------------------------------------------------
# en que se diferencia esto:
datos |>
  count(device_os) |>
  mutate(p = n/sum(n))

# de esto?
datos |>
  distinct(device_id, device_os) |>
  count(device_os) |>
  mutate(p = n/sum(n))


# distribución de hora de conexiones a internet ---------------------------
ggplot(datos) +
  geom_histogram(aes(hora))

# quizás algo menos detallado en un principio:
hm("7:00")

# (como SQL)
datos <- datos |>
  mutate(
    parte_dia = case_when(
      hora < hm("6:00") ~ "Madrugada",
      hora < hm("12:00") ~ "Mañana",
      hora < hm("19:00") ~ "Tarde",
      hora < hm("24:00") ~ "Noche"
    )
  )

datos |>
  count(parte_dia)

d1 <- datos |>
  count(parte_dia)

ggplot(d1) +
  geom_col(aes(parte_dia, n))

# por que ese orden?
# definiremos el orden!:
cat_parte_dia <- c("Madrugada", "Mañana", "Tarde", "Noche")

datos <- datos |>
  mutate(parte_dia = factor(parte_dia, levels = cat_parte_dia))

d1 <- datos |>
  count(parte_dia)

ggplot(d1) +
  geom_col(aes(parte_dia, n))

d2 <- datos |>
  count(parte_dia, comuna)

ggplot(d2) +
  geom_col(aes(parte_dia, n)) +
  facet_wrap(vars(comuna))

ggplot(d2) +
  geom_col(aes(parte_dia, n)) +
  facet_wrap(vars(comuna))
  facet_wrap(vars(comuna), scales = "free_y")

# Quizás agrupar por zonas?
datos |>
  mutate(
    zona = case_when(
      comuna %in% c("La Florida", "Puente Alto")  ~ "Zona Sur",
      comuna %in% c("Quilicura")  ~ "Zona Norte",
    )
  )

# Dispositivo con más registros -------------------------------------------
datos |>
  count(device_id, sort = TRUE)

# Dispositivos con más comunas --------------------------------------------
datos |>
  distinct(device_id, comuna) |>
  count(device_id, sort = TRUE)

# 2ad157d0-cccc-4b71-b2b1-fed253cfe5d0
# 315781b4-8dad-429b-a3a1-3364cffb2532

dispositivo <- datos |>
  filter(device_id == "315781b4-8dad-429b-a3a1-3364cffb2532") |>
  arrange(hora)

ggplot(dispositivo) +
  geom_point(aes(longitude, latitude))

dispositivo |>
  count(comuna, sort = TRUE)

ggplot(dispositivo, aes(longitude, latitude)) +
  geom_path(aes(color = fecha_hora), linewidth = 3) +
  scale_color_viridis_c() +
  theme(legend.position = "bottom")

dispositivo2 <- dispositivo |>
  select(-parte_dia, -hora)

p <- ggplot(dispositivo, aes(longitude, latitude)) +
  geom_path(color = "gray", data = dispositivo2) +
  geom_path(aes(color = fecha_hora), linewidth = 3) +
  facet_wrap(vars(parte_dia))

p

ggplot(dispositivo, aes(longitude, latitude)) +
  geom_path(color = "gray", data = dispositivo2) +
  geom_path(aes(color = fecha_hora), linewidth = 3) +
  facet_wrap(vars(hour(hora)))


# contexto ----------------------------------------------------------------
# gran santiago
gs <- sf::st_read("https://raw.githubusercontent.com/robsalasco/precenso_2016_geojson_chile/87bc72ea23ad19a116ae9af02fa1cb5ae06f29f3/Extras/GRAN_SANTIAGO.geojson")

gs <- as_tibble(gs)
gs <- sf::st_as_sf(gs)

gs <- rename_with(gs, str_to_lower)


# plot --------------------------------------------------------------------
ggplot() +
  # agregamos la informacion que viene del datoa geofráfico
  geom_sf(
    data = gs,
    aes(geometry = geometry)
  ) +
  # agregamos datos del dispositivo
  geom_path(
    data = dispositivo,
    aes(longitude, latitude, color = fecha_hora),
    linewidth = 3
    ) +
  facet_wrap(vars(parte_dia))



# coropletas --------------------------------------------------------------
# "pintado" comunas
glimpse(gs)

gs |> count(comuna)
gs |> count(nom_comuna)

datos |> count(comuna)

gs <- gs |>
  mutate(comuna = str_to_title(nom_comuna))

datos_comuna_pdia <- datos |>
  group_by(comuna, parte_dia) |>
  count()

gs2 <- left_join(gs, datos_comuna_pdia, by = "comuna")

glimpse(gs2)


ggplot() +
  geom_sf(
    data = gs2,
    aes(geometry = geometry, fill = n)
  ) +
  scale_fill_viridis_c() +
  facet_wrap(vars(parte_dia))

plotly::ggplotly()



# Desafío de proyecto -----------------------------------------------------
#
# 1. para dispositivo considrere la comuna más frecuente en la mañana para
#    considerarla punto de partidas
# 2. lo mismo anterior pero usando la comuna más frecuente de la tarde
#    para considerarla como comuna de destino.
# 3. intente recrear una mátriz de origen destino con los dispositivos que
#    poseen tanto comuna en la tabla de 1. y 2.
# 4. Use `geom_tile` para visualizar la relación.
# 5. Elimine comunas poco frecuentes/con pocos registros
# 6. Deberá normalizar por comuna de origen? Esto para no distorcionar los
#    resultados al comparar comunas con poco/mucha cardinalidad.


