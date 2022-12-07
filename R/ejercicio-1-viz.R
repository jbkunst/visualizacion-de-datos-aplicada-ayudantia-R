# Cargue los paquetes datos, ggplot2 y dplyr.
library(datos)
library(ggplot2)
library(dplyr)

# Ejecute glimpse(vuelos).
glimpse(vuelos)

# Objtenga una muestra de 10.000 registros para responder las preguntas utilizando la función sample_n (hint (?): sample_n(vuelos, 1000)).
vuelos_muestra <- sample_n(vuelos, 1000)

# ¿Cuántos filas/columnas tienen los datos?
glimpse(vuelos_muestra)

# ¿Cuántos datos son numéricos?
glimpse(vuelos_muestra)

# Explore la relación entre distancia y tiempo_vuelo.
ggplot(vuelos_muestra) +
  geom_point(aes(distancia, tiempo_vuelo))

ggplot(vuelos_muestra) +
  geom_point(aes(distancia, tiempo_vuelo), color = "gray50") +
  theme_minimal()

ggplot(vuelos_muestra) +
  geom_density_2d(aes(distancia, tiempo_vuelo))

# ¿Qué otras preguntas tienes? ¿Como podríamos obtener QUE vuelo es/son el/los más largos?


# Reutiliza el código del ejemplo paso a paso para utilizar la función facet_wrap con estos datos.
ggplot(vuelos_muestra, aes(distancia, tiempo_vuelo)) +
  geom_point(color = "gray50") +
  geom_smooth(method = "lm") +
  facet_wrap(vars(mes)) +
  theme_minimal()



