
#' @author: iubeda
#' Data Visualization

####################################################
##################### ggplot2 ######################
####################################################

#'ggplot2' es un paquete de visualización de datos que pertenece al 'tidyverse'
#Se basa en el libro 'Grammar of Graphics' (Leland Wilkinson, 1999)
#(https://www.amazon.com/Grammar-Graphics-Statistics-Computing/dp/0387245448)
# 2 características importantes:
# --> Los plots se crean a partir de distintas capas ('layers')
# --> Las variables se 'mapean' visualmente a través de lo que se llama 'aesthetic mapping'

#Elementos escenciales (type of layers):
# 1) Data --> lo vimos en detalle la clase pasada
# 2) Aesthetics --> lo veremos en esta sesión
# 3) Geometries --> lo veremos en esta sesión
# 4) Facets --> lo veremos en esta sesión
# 5) Statistics --> no lo veremos en esta sesión (aunque veremos geometrías equivalentes)
# 6) Coordinates --> no lo veremos en esta sesión
# 7) Themes --> lo veremos en esta sesión

main_dir = '/home/iubeda/Github Repo/taller-R/clase 4' #CAMBIAR POR PERSONAL
setwd(main_dir)

library(ggplot2)
library(dplyr)
library(tidyr)

#########################################################
args(ggplot)

#Problema Objetivo:
#Crear un clasificador de especies de flores según algunas medidas
#del largo y ancho del sépalo (sepal) y pétalo (petal)
head(iris)
str(iris)

#Antes de 'correr' cualquier clasificador, veamos si nuestros datos
#son separables a través de 2 análisis:
#1) Análisis univariado
#2) Análisis multivariado (en este caso, bivariado)

#############################################################
#PRELIMINARES
ggplot(iris, aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_point()

#Obs: ggplot2 también acepta trabajar con el 'pipe'

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_point()

#También podemos asignar el plot a una variable como si fuera un objeto de R y 
#luego mostrarlo (esto es MUY útil cuando queremos crear un plot 'base' y luego ir 
#agregandole más capas -> esto de las 'capas' lo veremos en detalle hoy)

plot = iris %>%
        ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
        geom_point()

str(plot, max.level = 1)
print(plot)

#Podemos además guardar nuestros gráficos con una función particular de ggplot2
args(ggsave)

fname = file.path('plot', 'scatter_plot.jpg')
ggsave(fname, plot, width = 26, height = 19.5, units = "cm", dpi = 200)

#Obs: por default se guarda el último plot mostrado
iris %>%
  ggplot(aes(x=Sepal.Width, y=Petal.Width)) + 
  geom_point()

fname = file.path('plot', 'scatter_plot2.jpg')
ggsave(fname, width = 26, height = 19.5, units = "cm", dpi = 200)

####################################################
################### Aesthetics #####################
####################################################

#Las variables se 'mapean' visualmente a través de aes()

#Ej:
#Suponga que, del plot anterior, quisieramos analizar si existe 
#alguna diferencia por especie

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, col = 'red')) + 
  geom_point()

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_point(col = 'red')

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, col = Species)) + 
  geom_point()

#Aquí la variable 'Species' ha sido mapeada al elemento 'color'

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_point(col = Species)

#Obs: aes() se encarga de hacer el mapping: var. dataset -> var. visual

# Y si quisieramos otro nombre en la legenda?
iris_change = iris
levels(iris_change$Species) = c('Seto', 'Versi', 'Virgi')

iris_change %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, col = Species)) + 
  geom_point()

#Así como el color, existen más variables visuales donde podemos mapear

#shape
iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, shape = Species)) + 
  geom_point()

#size
iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, size = Species)) + 
  geom_point()

#No tiene mucho séntido utilizar size con factores
#Sí con variables numéricas
iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, size = Petal.Width)) + 
  geom_point()

#mix
iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, 
             col = Species, size = Petal.Width)) + 
  geom_point()

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, 
             col = Species, size = Petal.Width, shape = Species)) + 
  geom_point()

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, 
             col = Species)) + 
  geom_point(shape = 1, size = 2, alpha = 0.4)

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length, 
             col = Species, alpha = Petal.Width)) + 
  geom_point(shape = 5, size = 4)

#Para saber cuales son los argumentos de alguna geometría 
#en particular (e.g. geom_point):
?geom_point


#APLICACIÓN
#1)
#Nos gustaría analizar ahora si existe alguna diferencia en el largo de 
#Petal-Sepal según la especie?

# Primer approach:
iris %>% 
  ggplot(aes(x = Species, y = Sepal.Length)) + 
  geom_point()

iris %>% 
  ggplot(aes(x = Species, y = Petal.Length)) + 
  geom_point()

#Problemas:
#1) Nos gustaría tener la info de Petal-Sepal en un mismo plot
#2) Los puntos no son muy buenos para mostrar distribuciones

#Segundo approach: 
# --> Sabemos ocupar dplyr y tidyr!!

iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  filter(dim == 'Length') %>%
  ggplot(aes(x = Species, y = value, col = Part)) + 
    geom_point()

#Solucionamos el problema (1), pero el (2) sigue

#Si nos gustaría analizar largo y ancho ahora, podemos juntar todo:
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  ggplot(aes(x = Species, y = value, col = Part, shape = dim)) + 
    geom_point()

#Regular-malo -> hay mucha información en un sólo plot
#Obs: NO sobrecargar los plots con información!!
#Más adelante veremos cómo mejorar esto =)

#2)
#Y si quisieramos plotear Sepal vs Petal (scatterplot)
#según Specie y dimensión?   

iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  group_by(Species, Part) %>%
  mutate(index = 1:n()) %>%
  ungroup() %>%
  spread(Part, value) %>%
  select(-index) %>%
  ggplot(aes(x = Petal, y = Sepal, col = Species, shape = dim)) + 
    geom_point(size = 2)

#Mejor, pero podría mejorar aún más.
#Necesitamos una forma de separar combinaciones de variables 
#(en este caso, species-dimensión) en diferentes plots --> Facetas!

#Obs: Es MUY importante tener claro cómo ggplot2 hace el mapping con 
#las variables pues esto determinará la estructura de dato
#que necesitamos como input. 

#Nota que para un mismo dataset, podemos necesitar cambiarle la forma 
#porque el plot que queremos lo requiere.

#--> Pensar cómo mostrar los datos es FUNDAMENTAL antes de 
#programar cualquier cosa

####################################################
##################### Facets #######################
####################################################

#Las facetas sirven para crear paneles (matrices) de plots
#Se pueden ajustar por filas y/o por columnas

#En nuestros ejemplos anteriores, el problema era que había mucha 
#información en un sólo plot.
#Si ahora mapeamos las variables a facetas:

#Sintaxis: facet_grid(filas ~ columnas)

#APLICACIÓN
#1)

#SIN FACETAS (último de sección anterior)
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  ggplot(aes(x = Species, y = value, col = Part, shape = dim)) + 
  geom_point()

#CON FACETAS
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  ggplot(aes(x = Species, y = value, col = Part)) + 
  geom_point() + 
  facet_grid(.~dim) #sólo columnas

iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  ggplot(aes(x = Species, y = value, col = Part)) + #también se puede mapear en aes() 
  geom_point() + 
  facet_grid(Part~dim) #fila y columnas

#Mucho mejor (en términos de no sobrecargar información)
#Sin embargo los puntos siguen siendo malos para mostrar distribuciones
#Debemos cambiar la geometría!! --> Próxima sección

#2)
#SIN FACETAS (último de sección anterior)
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  group_by(Species, Part) %>%
  mutate(index = 1:n()) %>%
  ungroup() %>%
  spread(Part, value) %>%
  select(-index) %>%
  ggplot(aes(x = Petal, y = Sepal, col = Species, shape = dim)) + 
  geom_point(size = 2)

#CON FACETAS
#Filas y columnas
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  group_by(Species, Part) %>%
  mutate(index = 1:n()) %>%
  ungroup() %>%
  spread(Part, value) %>%
  select(-index) %>%
  ggplot(aes(x = Petal, y = Sepal, col = dim)) + 
  geom_point(size = 2) + 
  facet_grid(Species~dim)

#Sólo filas
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  group_by(Species, Part) %>%
  mutate(index = 1:n()) %>%
  ungroup() %>%
  spread(Part, value) %>%
  select(-index) %>%
  ggplot(aes(x = Petal, y = Sepal, col = dim, shape = dim)) + 
  geom_point(size = 2) + 
  facet_grid(Species~.)

#Sólo columnas
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  group_by(Species, Part) %>%
  mutate(index = 1:n()) %>%
  ungroup() %>%
  spread(Part, value) %>%
  select(-index) %>%
  ggplot(aes(x = Petal, y = Sepal, col = dim)) + 
  geom_point() + 
  facet_grid(.~Species)


####################################################
################### Geometries #####################
####################################################

#Hasta el momento, la única geometría que hemos visto han sido puntos:
#(geom_point). Sin embargo, existen muchas más:
geom_

#Obs: a su vez, cada geometría tiene sus propios parámetros
#(aunque comparten muchos entre ellos)

#En esta sección veremos las más típicas (además de geom_point):

#line
iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_line()

#lineas verticales y horizontales (útiles para remarcar algún valor)
iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_hline(yintercept = 4, col = 'blue')

iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_vline(xintercept = 4, col = 'blue')

#linear model
iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_smooth(method='lm', col = 'red')

#Podemos usar además más de una geometría! (filosofía por 'capas')
iris %>%
  ggplot(aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_point(color = 'black') + 
  geom_smooth(method='lm', col = 'red') + 
  geom_hline(yintercept = 8, col = 'blue') + 
  geom_hline(yintercept = 1, col = 'blue') 
  
#Para análisis univariado, también existen geometrías en particular:

#histogramas
iris %>%
  ggplot(aes(x=Sepal.Length)) + 
  geom_histogram(bins = 10) 

#boxplot
iris %>%
  ggplot(aes(x = 1, y=Sepal.Length)) + 
  geom_boxplot()

#densidad
iris %>%
  ggplot(aes(x=Sepal.Length)) + 
  geom_density()

#ajustar densidad a histograma
iris %>%
  ggplot(aes(x=Sepal.Length)) + 
  geom_histogram(binwidth = 0.5) + 
  geom_density(aes(y = 0.5 * ..count..))

#Obs: esto, sumado a lo que hemos visto hasta el momento 
#(aesthetics y facetas) es más que suficiente para hacer los plots
#más utilizados.

#APLICACIÓN
#1)
#geometría anterior
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  ggplot(aes(x = Species, y = value, col = Part)) + #también se puede mapear en aes() 
  geom_point() + 
  facet_grid(Part~dim) 

#geometría nueva
univ_plot = iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  ggplot(aes(x = Species, y = value, col = Part)) + #también se puede mapear en aes() 
  geom_boxplot() + 
  facet_grid(Part~dim) 

print(univ_plot)

#2)
#geometría anterior
iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  group_by(Species, Part) %>%
  mutate(index = 1:n()) %>%
  ungroup() %>%
  spread(Part, value) %>%
  select(-index) %>%
  ggplot(aes(x = Petal, y = Sepal, col = dim)) + 
  geom_point(size = 2) + 
  facet_grid(Species~dim)

#geometría nueva
biv_plot = iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("Part", 'dim'), sep = '\\.') %>%
  group_by(Species, Part) %>%
  mutate(index = 1:n()) %>%
  ungroup() %>%
  spread(Part, value) %>%
  select(-index) %>%
  ggplot(aes(x = Petal, y = Sepal, col = dim)) + 
  geom_point(size = 2, alpha = 0.3, col = 'black') +
  geom_smooth(method = 'lm', alpha = 1) + 
  facet_grid(Species~dim)

print(biv_plot)

#Conclusión: 
#Los variables de las flores son separables por especie a simple vista 
#por lo que hace sentido aplicarle algún modelo de clasificación lineal  

####################################################
##################### Themes #######################
####################################################

#Themes es todo lo que se refiere al plot que NO es dato
#Aquí seteamos título de ejes, título del plot, entre muchas
#otras cosas más 

#La filosofía es la misma --> Por 'capas'
args(theme)

#APLICACIÓN
#1) 

#plot anterior
univ_plot

#plot nuevo 
univ_plot + 
  ggtitle('Boxplot distribution over Species') + 
  xlab('Especies') + 
  labs(col = 'Parte') + #legenda 
  theme(plot.title = element_text(hjust = 0.5, color = 'red'),
        axis.title.y = element_blank(),
        legend.title = element_text(face = 'bold'),
        legend.text = element_text(size = 10, color = 'blue'),
        axis.text.x = element_text(angle = 60, hjust = 1.2)
        ) 

fname = file.path('plot', 'univariate_plot_final.jpg')
ggsave(fname, width = 26, height = 19.5, units = "cm", dpi = 200)

#Obs:
#Los argumentos de 'theme' deben ser de tipo 'element_text'
args(element_text)
#'element_blank' deja en blanco un elemento

#2) 

#plot anterior
biv_plot

#plot nuevo 
biv_plot + 
  ggtitle('Sépalo-Pétalo scatter-plot') + 
  xlab('Pétalo') +
  ylab('Sépalo') +
  labs(col = 'Dimensión') + 
  theme(plot.title = element_text(size = 15, hjust = 0.5, 
                                  face = 'italic')) 

fname = file.path('plot', 'bivariate_plot_final.jpg')
ggsave(fname, width = 26, height = 19.5, units = "cm", dpi = 200)

######################################################################
#Hay muchos temas pendientes que no alcanzamos a ver 
#(e.g. stats, coordinates, scales). Uno importante por ejemplo es el siguiente:

ggplot() + 
  geom_point(data = iris, mapping = aes(x=Sepal.Length, y=Petal.Length))

#Podemos definir la data y el mapping dentro de la geometría :O!!
#Esto es MUY útil cuando queremos hacer un mismo plot con diferentes
#fuentes de información (i.e. dataframes)!!

######################################################################

#APLICACIÓN FINAL (WRAP-UP) DEL TALLER

#Nos gustaría saber qué clasificador tiene el mayor accuracy
#según tipo de conjunto y selector y para cada nº de features:
fname = file.path('data', 'model_results_long.csv')
df_info = read.csv(fname, sep = ";", header = T) %>% as_data_frame()
str(df_info)

df_info %>%
  ggplot(aes(x = n_features, y = accuracy, color = clf_name)) + 
  facet_grid(set ~ selector_name) + 
  geom_line() + 
  geom_hline(yintercept=0.95, linetype = 'dashed', color = 'red') + 
  scale_y_continuous(limits = c(0,1), breaks = seq(0,1,0.1)) + 
  xlab('nº features') + ylab('accuracy') + 
  labs(col = 'Classifier') + 
  ggtitle('Accuracy accros number of features by set-selector and classifier') + 
  theme(plot.title = element_text(hjust = 0.5), 
        axis.text.x = element_text(angle = 60, hjust = 1.2))

fname = file.path('plot', 'accuracy_plot.jpg')
ggsave(fname, width = 26, height = 19.5, units = "cm", dpi = 200)