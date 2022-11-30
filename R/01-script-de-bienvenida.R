# primero ejecutar R/00-instalar-dependencias.R

# cargar paquetes
library(tidyverse)
library(datos)

# datos
paises

# inspeccionar datos
glimpse(paises)

# filtrar datos (por que?)
paises2 <- filter(paises, anio == max(anio))


# explorar ----------------------------------------------------------------
ggplot(paises2) +
  geom_point(aes(pib_per_capita, esperanza_de_vida))

ggplot(paises2) +
  geom_point(aes(pib_per_capita, esperanza_de_vida, size = poblacion))

ggplot(paises2) +
  geom_point(
    aes(pib_per_capita, esperanza_de_vida, size = poblacion),
    color = "gray70"
    )

ggplot(paises2) +
  geom_point(
    aes(pib_per_capita, esperanza_de_vida, size = poblacion, color = continente)
  )

ggplot(paises2) +
  geom_point(
    aes(pib_per_capita, esperanza_de_vida, size = poblacion, color = continente)
  ) +
  scale_color_viridis_d() +
  scale_x_continuous(labels = scales::dollar) +
  labs(
    x = "PIB per cápita",
    y = "Esperanza de vida",
  )

p <- ggplot(paises2) +
  geom_point(
    aes(pib_per_capita, esperanza_de_vida, size = poblacion, color = continente)
  ) +
  scale_color_viridis_d() +
  scale_x_continuous(labels = scales::dollar) +
  labs(
    title = "Como impacta el PIB",
    x = "PIB per cápita",
    y = "Esperanza de vida",
  )

p

p +
  scale_x_log10()

p +
  scale_x_log10() +
  geom_smooth(aes(pib_per_capita, esperanza_de_vida), method = "lm")


p2 <- p +
  scale_x_log10(labels = scales::dollar) +
  geom_smooth(aes(pib_per_capita, esperanza_de_vida), method = "lm") +
  facet_wrap(vars(continente)) +
  theme_minimal()

p2

# guardar!
ggsave(plot = p2, filename = "outputs/pib_per_capita.jpg", width = 16, height = 9, scale = 1/2)


# animaciones -------------------------------------------------------------
library(gganimate)
# https://gganimate.com/

# notar que usamos paises (no paises 2)
ggplot(
  paises,
  aes(pib_per_capita, esperanza_de_vida, size = poblacion, color = continente)
  ) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_color_viridis_d() +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  # Particular para gganimate
  labs(title = 'Anio: {frame_time}', x = 'GDP per capita', y = 'Esperanza de vida') +
  transition_time(anio) +
  ease_aes('linear')


# interactivos ------------------------------------------------------------
library(highcharter)
# https://jkunst.com/highcharter/

hc <- hchart(
  paises2,
  "bubble",
  hcaes(pib_per_capita, esperanza_de_vida, size = poblacion, group = continente)
  ) |>
  hc_add_theme(hc_theme_hcrt())

hc

# guardar y mandar por mail!
htmlwidgets::saveWidget(hc, "outputs/pib_per_capita.html", selfcontained = TRUE)

