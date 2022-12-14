# Instala paquetes necesarios para la ayudantia.
#
# Paquetes (packages): conjunto de funciones (encapsuladas)
#
# Funciones: Un elemento que recibe 1 o mas parámetros/elementos y retorna uno o más valores

install.packages(
 c("tidyverse",
   "datos",
   "highcharter",
   "leaflet",
   "gganimate",
   "plotly",
   "data.table",
   "R.utils",
   "forecast",
   "DT",
   "rvest",
   "leaflet",
   "sf"
 )
)


# elementos ---------------------------------------------------------------
x <- c(5, 4)
x

df <- data.frame(x = c(2, 3, 4), y = c("A", "B", "B"))
df


# funciones ---------------------------------------------------------------
sum(c(4, 2))

aggregate(x ~ y, data = df, FUN = mean)
