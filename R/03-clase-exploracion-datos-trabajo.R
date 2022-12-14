library(tidyverse) # dplyr, ggplot2, y amigos
library(lubridate)

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

ggplot(datos) +
  geom_bar(aes(parte_dia))

# por que ese orden?
# definiremos el orden!:
cat_parte_dia <- c("Madrugada", "Mañana", "Tarde", "Noche")

datos <- datos |>
  mutate(parte_dia = factor(parte_dia, levels = cat_parte_dia))

ggplot(datos) +
  geom_bar(aes(parte_dia))

ggplot(datos) +
  geom_bar(aes(parte_dia)) +
  facet_wrap(vars(comuna))

ggplot(datos) +
  geom_bar(aes(parte_dia)) +
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


# Dispositivos con más comunas --------------------------------------------
datos |>
  distinct(device_id, comuna) |>
  count(device_id, sort = TRUE)
# 2ad157d0-cccc-4b71-b2b1-fed253cfe5d0
# 315781b4-8dad-429b-a3a1-3364cffb2532
dispositivo <- datos |>
  filter(device_id == "2ad157d0-cccc-4b71-b2b1-fed253cfe5d0") |>
  arrange(hora)


ggplot(dispositivo) +
  geom_point(aes(longitude, latitude))


ggplot(dispositivo, aes(longitude, latitude)) +
  geom_path(aes(color = fecha_hora), size = 3) +
  theme(legend.position = "bottom")


dispositivo2 <- dispositivo |>
  select(-parte_dia, -hora)

ggplot(dispositivo, aes(longitude, latitude)) +
  geom_path(color = "gray", data = dispositivo2) +
  geom_path(aes(color = fecha_hora), size = 3) +
  facet_wrap(vars(parte_dia))

ggplot(dispositivo, aes(longitude, latitude)) +
  geom_path(color = "gray", data = dispositivo2) +
  geom_path(aes(color = fecha_hora), size = 3) +
  facet_wrap(vars(hour(hora)))



