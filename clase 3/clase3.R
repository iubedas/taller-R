
#' @author: iubeda
#' Data Manipulation

####################################################
################# Importing data ###################
####################################################

#FORMAS DE IMPORTAR ARCHIVOS (ej: csv) : 
#1) Darle el "path" absoluto a la función
data_read_csv = read.csv('/home/iubeda/Github Repo/taller-R/clase 3/data/SacramentocrimeJanuary2006.csv')
rm(data_read_csv)

#2) Setear el working directory al lugar donde están los archivos
getwd()
data_dir = '/home/iubeda/Github Repo/taller-R/clase 3/data'
setwd(data_dir)
dir(getwd())

data_read_csv = read.csv('SacramentocrimeJanuary2006.csv')
rm(data_read_csv)
#3) Setear el working directory al main directory y usar paths relativos 
#(este usaremos en esta clase (recomendación personal))
main_dir = '/home/iubeda/Github Repo/taller-R/clase 3' #CAMBIAR POR PERSONAL
setwd(main_dir)
dir(getwd())

data_read_csv = read.csv('data/SacramentocrimeJanuary2006.csv')
rm(data_read_csv)

#FUNCIONES SEGÚN TIPO DE EXTENSIÓN:

#.CSV 
args(read.csv)
data_read_csv = read.csv('data/SacramentocrimeJanuary2006.csv')
head(data_read_csv, 3)
str(data_read_csv)
#stringAsFactors = T por default -> convierte "character" a "factor"

data_read_csv = read.csv('data/SacramentocrimeJanuary2006.csv', stringsAsFactors = F)
str(data_read_csv)

#obs: también existe read.csv2
args(read.csv2) 
args(read.csv) 
#diferencias en argumentos por default: sep, dec
rm(data_read_csv)

#.TXT
args(read.delim)
data_read_txt = read.delim('data/votacion_concejales_2012.txt')
head(data_read_txt, 3)
str(data_read_txt)

data_read_txt = read.delim('data/votacion_concejales_2012.txt', stringsAsFactors = F)
str(data_read_txt)

data_read_txt = read.delim('data/votacion_concejales_2012.txt', header = F, dec = ',')
head(data_read_txt, 3)
str(data_read_txt)
#colnames(data_read_txt) = c('candidato', 'partido', 'total', 'porcentaje')

#definir nombre y clase de columnas DENTRO de la función que importa 
data_read_txt = read.delim('data/votacion_concejales_2012.txt', header = F, dec = ',',
                           col.names = c('candidato', 'partido', 'total', 'porcentaje'),
                           colClasses = c('character', 'character', 'numeric', 'numeric'))
str(data_read_txt)

#obs: también existe read.delim2
args(read.delim2) 
args(read.delim) 
#diferencias en argumentos por default: dec
rm(data_read_txt)

#OJO read.csv (read.csv2) y read.delim (read.delim2) son implementaciones de 
#read.table con diferentes parámetros por default
# -> read.table es la función "base" (más general)

args(read.table)

#.CSV
data_read_table_csv = read.table('data/SacramentocrimeJanuary2006.csv')
data_read_table_csv = read.table('data/SacramentocrimeJanuary2006.csv', header = T, 
                             sep = ",", quote = "\"", dec = ".", fill = T, 
                             stringsAsFactors = F)
str(data_read_table_csv)
rm(data_read_table_csv)

#.TXT
data_read_table_txt = read.table('data/votacion_concejales_2012.txt')
data_read_table_txt = read.table('data/votacion_concejales_2012.txt', header = F, 
                                 sep = "\t", quote = "\"", dec = ",", fill = T,
                                 col.names = c('candidato', 'partido', 'total', 'porcentaje'),
                                 colClasses = c('character', 'character', 'numeric', 'numeric'))
str(data_read_table_txt)
rm(data_read_table_txt)

#Obs: usar read.table + control flow + do.call

#ESCOGER ARCHIVOS MANUALMENTE
file.choose()
data_read_csv = read.csv(file.choose(), stringsAsFactors = F)
str(data_read_csv)
rm(data_read_csv)

#Función útil para definir paths
file.path('data', 'nombre_archivo.csv')

#Ej:
data_read_csv = read.csv(file.path('data', 'SacramentocrimeJanuary2006.csv'), stringsAsFactors = F)
str(data_read_csv)
rm(data_read_csv)


#.XLS - .XLSX files
library(readxl) 

file_name = file.path('data', 'sample-xlsx-file.xlsx')
sheets = excel_sheets(file_name)
sheets

args(read_excel)

#default:
data_read_excel = read_excel(file_name)
data_read_excel

#por nº de hoja
data_read_excel = read_excel(file_name, sheet = 2)
data_read_excel

#por nombre de hoja
data_read_excel = read_excel(file_name, sheet = sheets[2])
data_read_excel  
  
#leer workbook completo  
workbook = mapply(read_excel, sheets, path = file_name)
str(workbook, max.level = 1)
str(workbook)

#Obs: hay más paquetes para leer archivos excel desde R: 
#Ej: XLConnect, xlsx, entre otros.
#Busca el que se ajuste mejor a tus necesidades! 
rm(data_read_excel); rm(workbook); rm(file_name); rm(sheets)

####################################################
################ Type conversion ###################
####################################################

#Por lo general lo usamos para cambiar el formato de las columnas de nuestro dataframe
mtcars_change = mtcars
str(mtcars_change)

#Los más utilizados son:
# as.numeric()
# as.character()
# as.factor()
# as.integer()

#Ej:

#numeric -> character
mtcars_change$mpg = as.character(mtcars_change$mpg)
mtcars_change$disp = as.character(mtcars_change$disp)
str(mtcars_change)

#numeric -> factor
mtcars_change$carb = as.factor(mtcars_change$carb)
str(mtcars_change)

#character -> factor
mtcars_change$disp = as.factor(mtcars_change$disp)
str(mtcars_change)

#character -> numeric
mtcars_change$mpg = as.numeric(mtcars_change$mpg)
str(mtcars_change)

#factor -> numeric
mtcars_change$disp = as.numeric(mtcars_change$disp)
str(mtcars_change)

#FORMATEAR TODAS LAS COLUMNAS -> as. + apply family
mtcars_change = mtcars
str(mtcars_change)

mtcars_change = lapply(mtcars_change, as.character)
str(mtcars_change)

mtcars_change = as.data.frame(mtcars_change, stringsAsFactors=F)
str(mtcars_change)

#Objetos completos:
#data.frame -> matrix & matrix -> data.frame
#data.frame -> list & list -> data.frame
class(mtcars)
class(as.matrix(mtcars))
class(as.data.frame(as.matrix(mtcars)))

#hay MUCHOS más: as.nombre

rm(mtcars_change)

####################################################
################# Pipe operator ####################
####################################################

#El operador pipe "%>%" pertenece al paquete "magrittr".
#Sin embargo, "magrittr" se importa siempre que importemos algún paquete 
#del "tidyverse" (en particular: tidyr, dplyr, ggplot2)

#Es MUY ÚTIL para la composición de funciones o "concatenación" de operaciones 
#que utilizan resultados intermedios:

# x %>% f() es equivalente a f(x)
# x %>% f(y) es equivalente a f(x,y) 
# x %>% f(y) %>% g() es equivalente a g(f(x,y))

library(magrittr)
x = c(1,3,5,7)

sum(x)
x %>% sum()
x %>% (function(x) {x^2}) #también se puede utilizar con funciones 'on-line' 

#MALA FORMA:
r = x^2
r = sum(r)
r = sqrt(r)
print(r)

#BUENA FORMA
r = x %>% (function(x) {x^2}) %>% sum() %>% sqrt()
print(r)

#también se puede utilizar el "argument placeholder" (.)
# x %>% f(y, .) es equivalente a f(y,x)
# x %>% f(y, z = .) es equivalente a f(y, z = x)
# x %>% f(y = nrow(.), z = ncol(.)) es equivalente a f(x, y = nrow(x), z = ncol(x))

#más info:
# https://magrittr.tidyverse.org/
rm(x); rm(r)

####################################################
################# Dplyr package ####################
####################################################

#"dplyr" es un paquete para manipulación de datos:

#En esta sección veremos 6 funciones importantes:
# select -> selecciona columnas del dataframe
# mutate -> agrega nuevas columnas al dataframe según las existentes
# filter -> filtra por alguna condición en alguna columna del dataframe
# arrange -> ordena el dataframe
# summarise -> crea un summary de nuestro dataframe (agrega)
# group_by -> agrupa por alguna(s) columna

library(dplyr)

data = read.csv('data/model_results_wide.csv', sep = ';') %>% as_data_frame()
head(data)
str(data)
glimpse(data) # parecida a str pero particular de 'dplyr'

#SELECT
#por nombre de columna
data_subset = data %>% select(set, selector_name, extratree, svm)
head(data_subset)
#Obs: podemos renombrar nuestras columnas si es que redefinimos el nombre de ella dentro del select
#para eso también existe la función "rename"

#contains
data_subset = data %>% select(Conjunto = set, Selector = selector_name, 
                              contains('tree'))
head(data_subset)

#starts_with
data_subset = data %>% select(Conjunto = set, Selector = selector_name, 
                              starts_with('extra'))
head(data_subset)

#ends_with
data_subset = data %>% select(Conjunto = set, Selector = selector_name, 
                              ends_with('boost'))
head(data_subset)

#todo menos + mix
data_subset = data %>% select(-starts_with('extra'), -ends_with('boost'))
head(data_subset)


#MUTATE
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, ends_with('boost')) %>%
              mutate(suma_entre_cols = adaboost + gradientboost,
                     relat_diff = (adaboost - gradientboost)/gradientboost)
head(data_subset)

#OJO con funciones dentro del mutate, estas se aplican a la columna completa y 
#NO fila por fila
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, ends_with('boost')) %>%
              mutate(max_adaboost = max(adaboost),
                     max_gradientboost = max(gradientboost))
head(data_subset)

#Para explicitar que la función debe ser por fila debemos agregar la función "rowwise"
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, ends_with('boost')) %>%
              rowwise() %>%
              mutate(max_entre_cols = max(c(adaboost,gradientboost)))
head(data_subset)


#FILTER
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, ends_with('boost')) %>%
              filter(gradientboost >= 0.9)
head(data_subset)

#and
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, ends_with('boost')) %>%
              filter(Conjunto == 'sets_wmedian', gradientboost >= 0.9) #and 
              #filter(Conjunto == 'sets_wmedian' & gradientboost >= 0.75)
head(data_subset)

#or
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, ends_with('boost')) %>%
              filter(gradientboost >= 0.9 | adaboost <= 0.3) #or
head(data_subset)

#mix
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, ends_with('boost')) %>%
              filter(Selector == 'rfe', gradientboost >= 0.9 | adaboost <= 0.3) #or
head(data_subset)


#ARRANGE
#por default, ordena de forma creciente
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              arrange(extratreeS)
head(data_subset)

#desc() -> decreciente
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              arrange(desc(extratreeS))
head(data_subset)

#ordenar por más columnas
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              arrange(desc(extratreeS), extratree)
head(data_subset)

data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              arrange(desc(extratreeS), desc(extratree))
head(data_subset)

#Obs: También podemos ordenar por columnas que son tipo factor o character
#el orden es el típico orden de strings ("por vocabulario")

#SUMMARISE
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              summarise(max = max(extratreeS), 
                        mean = mean(extratreeS),
                        min = min(extratreeS),
                        count = n()) #n() retorna la cuenta de filas -> particular de 'dplyr'
head(data_subset)

#GROUP_BY
#Utilizado principalmente para agrupar por factores 
#(aunque también pueden ser por character o int -> es buena práctica convertir a factor primero)
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              group_by(Conjunto, Selector)
head(data_subset)

#Podemos agrupar y desagrupar también -> ungroup()
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              group_by(Conjunto, Selector) %>%
              ungroup()
head(data_subset)

#Obs: El uso comun es agrupar-aplicar-desagrupar
#Ej:
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              group_by(Conjunto, Selector) %>%
              mutate(max_extratreeS = max(extratreeS),
                     max_extratree = max(extratree)) %>%
              ungroup()
View(data_subset)

data_subset %>% 
  select(-extratree, -extratreeS) %>%
  unique()

#Obs: "GROUP_BY" por sí solo no tiene mucha utilidad.
#Por lo general lo utilizamos con alguno de las otras funciones de dplyr
#Ej: 
data_subset = data %>% 
              select(Conjunto = set, Selector = selector_name, starts_with('extra')) %>%
              group_by(Conjunto, Selector) %>%
              summarise(max_extratreeS = max(extratreeS), 
                        max_extratree = max(extratree))
head(data_subset)
#(mismo que anterior pero sin 'unique')              

#más info:
# https://dplyr.tidyverse.org/

#APLICACIÓN:
#Para el clasificador ExtraTrees (extratreeS), 
#cuál es el nª de features que maximiza el accuracy en cada grupo (set-selector)?

data %>% 
  select(set, selector_name, n_features, accuracy = extratreeS) %>%
  group_by(set, selector_name) %>%
  mutate(max_accuracy = max(accuracy)) %>%
  filter(max_accuracy == accuracy) %>%
  select(-max_accuracy) %>%
  arrange(desc(accuracy))

rm(data); rm(data_subset)

####################################################
################## Tidying data ####################
####################################################

#"tidyr" es un paquete para cambiar la forma de nuestros datos ("Reshape data")

#MOSTRAR IMÁGENES (1-4)

library(tidyr)

#En esta sección veremos 4 funciones importantes:
#gather -> wide to long
#spread -> long to wide
#unite -> unite multiple column into one
#separate -> separate one column into multiple

data_wide = read.csv(file.path('data', 'model_results_wide.csv'), sep = ";")
data_long = read.csv(file.path('data', 'model_results_long.csv'), sep = ";")

#GATHER
args(gather)
data_subset = data_wide %>% 
              select(set, selector_name, n_features, ends_with('boost')) 

head(data_subset)

data_subset = data_subset %>%
              gather('clf_name', 'accuracy', adaboost, gradientboost)
head(data_subset)
rm(data_subset)

#todo menos
head(data_wide)

data = data_wide %>% gather('clf_name', 'accuracy', -set, -selector_name, -n_features)
head(data)
rm(data)


#SPREAD
args(spread)
head(data_long)

data = data_long %>% spread(clf_name, accuracy)
head(data)
rm(data)

rm(data_long); rm(data_wide)


#UNITE
args(unite)
data = read.csv(file.path('data','SacramentocrimeJanuary2006.csv'))
head(data)

#unir 2 columnas
data_unite = data %>% unite(new_col, c(district, ucr_ncic_code), sep = '_')
head(data_unite)

#unir 3 columnas
data_unite = data %>% unite(new_col, c(district, ucr_ncic_code, grid), sep = '-')
head(data_unite)

#Obs: También funciona si referenciamos las columnas como caracteres
data_unite = data %>% unite('new_col', c('district', 'ucr_ncic_code', 'grid'), sep = '-')
head(data_unite)


#SEPARATE
args(separate)

data_separate = data_unite %>% separate(new_col, c(dist, code, grid), sep = '-')

#Obs: en el caso de separate las nuevas columnas (into) DEBEN ser caracteres!
data_separate = data_unite %>% separate('new_col', c('dist', 'code', 'grid'), sep = '-')
head(data_separate)

data_separate = data_unite %>% separate(new_col, c('dist', 'code', 'grid'), sep = '-')
head(data_separate)

rm(data); rm(data_unite); rm(data_separate)

#más info:
#http://www.sthda.com/english/wiki/tidyr-crucial-step-reshaping-data-with-r-for-easier-analyses

#MOSTRAR IMÁGENES (5)

#APLICACIÓN:
head(iris)
str(iris)
View(iris)
#Cual es la especie que tiene el largo promedio mayor (tanto en Sepal como Petal)??

iris %>% 
  as_data_frame() %>%
  gather(type, value, -Species) %>%
  separate(type, c("form", 'dim'), sep = '\\.') %>%
  filter(dim == "Length") %>%
  group_by(Species, form) %>%
  summarise(mean = mean(value),
            sd = sd(value)) %>%
  arrange(desc(mean))

#Obs: por lo general usamos 'tidyr' junto con 'dplyr' para manipulación de datos
#Y si quisieramos visualizar? -> ggplot2 también es parte del tidyverse! (PRÓXIMA CLASE)

########################################################################################
########################################## FIN #########################################
########################################################################################

####################################################
################### Bind data ######################
####################################################

#Sirve para agregar columnas o filas a un dataframe (DF):
#Ojo: para agregar una fila debe tener la misma cantidad de columnas
#mientras que para agregar una columna debe tener la misma cantidad de filas

#Funciones de 'base'
rbind #filas
cbind #columnas

#Funciones de 'dplyr' (recomendadas si estamos utilizando funciones de dplyr)
bind_rows #filas
bind_cols #columnas

#A diferencia de mutate, en bind_cols podemos "pegarle" una columna a un DF de otro DF.
#En cambio mutate genera nuevas columnas BASADAS en las columnas originales de nuestro DF

####################################################
################### Join data ######################
####################################################

#Sirve para combinar 2 dataframes a través de una columna "llave" (key)
#Son funciones de dplyr por lo que se integran bien con todo el tidyverse también
#Si quisiera combinar más de 2 DF -> join + pipe operator !! (+ dplyr y tidyr si fuera necesario)

file_name = file.path('data', "sample-xlsx-file.xlsx")
workbook = mapply(read_excel, excel_sheets(file_name), path = file_name)

#Este paso no es necesario, es sólo para hacerlo más claro
df_employee = workbook$Employee
df_department = workbook$Department

head(df_employee)
head(df_department)

#Queremos hacer un join en la columna "Department" de la tabla "Employee" con la columna
#"Name" en la tabla "Department" (i.e. nuestra llave tiene diferentes nombres en cada DF)

args(left_join)
join_data = left_join(df_employee, df_department, by = c("Department" = "Name"))
head(join_data)

#Si ambas columnas tuviera el mismo nombre (e.g. "Department") basta con:
# left_join(df_employee, df_department, by = "Department)

#También podemos el join por más de una columna!
#Supongamos que nuestras llave ahora son las columnas "Department" y "Salary" en el DF de "Employee"
#y "Name" y "Budget" en el DF de "Department", respectivamente. El join sería:

# left_join(df_employee, df_department, by = c("Department" = "Name", "Salary" = "Budget"))

#Y al igual que con una columna key, si ambas keys tuvieran el mismo nombre en los 2 DFs
#(e.g. "Deparment" y "Salary), bastaría con:

# left_join(df_employee, df_department, by = c("Department", "Salary"))

rm(file_name); rm(workbook); rm(df_department); rm(df_employee); rm(join_data)
#Existen 6 tipos de join distintos -> ver IMÁGENES (6)

#Mutating joins
args(left_join)
args(right_join)
args(inner_join)
args(full_join)

#Filtering joins
args(semi_join)
args(anti_join)


#más info:
# https://dplyr.tidyverse.org/reference/join.html




