
#' @author: iubeda
#' R-Programming

####################################################
############### SHORTCUTS de RStudio ###############
####################################################

# 1) Con el símbolo '#' se hacen comentarios
# 2) Con el comando CTRL+SHIFT+C se comentan/descomentan 'bloques de comentarios':
# Comentario 1
# Comentario 2
# 3) Con el comando CTRL+ENTER se ejecutan las líneas de código seleccionadas
print('Hello world')
print('Bye world')
# 4) Si no se seleciona nada, con el comando anterior se ejecuta 'línea por línea'
print('Hello world')
print('Bye world')
# 5) Con el comando CTRL+SHIFT+ENTER se ejecuta el script completo

####################################################
################# Data Structures ##################
####################################################
MAIN_DIR = '/home/iubeda/Documents/Taller de R - Tutoría DII/Clase 1' #cambiar por personal
setwd(MAIN_DIR)
getwd() #check

#VARIABLES
x = 2
class(x) 

x = 2.3 #redefine
class(x) 

x = as.integer(2)
class(x)

x = as.integer(2.8)
class(x)
print(x)

y = 'str'
class(y) 

b = T #T/F
class(b)

#VECTORES
v1 = c(1,2,3,4,5,6)
class(v1)
length(v1)
length(x) #variables son vectores de largo 1!
v1 = c(1:6)
print(v1)

v2 = c(1.3,2.5,3)
class(v2)

print(v1 + v2) #broadcast

v3 = c('str1', 'str2', 'str3')
class(v3)

v4 = c(1.2, 'str2', 3, T)
class(v4) #coercion -> todas las componentes del vector deben ser del mismo tipo
print(v4) 

v5 = c(T, F, T, T, F)
class(v5)

#MATRICES
#se crean a partir de vectores
print(v1)
length(v1)

m1 = matrix(v1, ncol = 3, nrow = 2, byrow = F)
class(m1)
print(m1)

#shape
length(m1)
dim(m1)
nrow(m1)
ncol(m1)

m1 = matrix(v1, ncol = 2, nrow = 2, byrow = F)
print(m1)

m1 = matrix(v1, ncol = 2, nrow = 2, byrow = T)
print(m1)

m1 = matrix(v1)
print(m1)
dim(m1)

m1 = matrix(v1, ncol = 5, nrow = 6, byrow = T)
print(m1)

#obs: como las matrices se construyen a partir de vectores, 
#aceptan sólo un tipo de dato en sus componentes 
m2 = matrix(c('str', T, 1.2))
print(m2) #coercion

#FACTORES
#se crean a partir de vectores
#son muy útiles para trabajar con variables categóricas

f1 = factor(v1)
class(f1)
print(f1)
levels(f1)
class(levels(f1))

f2 = factor(c(1,2,3,1,5,6))
print(f2)
levels(f2)
levels(f2) = c('n1', 'n2', 'n3', 'n5', 'n6')
print(f2)

#DATAFRAMES
#es la estructura de dato 'insignia' de R: datos tabulados
#se puede construir desde vectores, matrices y factores
#cada columna del dataframe es un vector 
#lo anterior implica que los dataframes tienen el mismo tipo de dato POR COLUMNA

#por ej desde una matriz:
df1 = data.frame(m1)
class(df1)
print(df1)

#mismas funciones de shape que matrices
length(df1) #OJO el largo ya no son el nº de elementos, sino el nº de columnas 
length(m1) 

dim(df1)
nrow(df1)
ncol(df1)

#nombres de filas y columnas -> vectores
colnames(df1) # == names(df1)
rownames(df1)

#setear nombre de columnas o filas
colnames(df1) = c('col1', 'col2', 'col3', 'col4', 'col5')
rownames(df1) = c('id1','id2','id3','id4','id5', 'id6')
print(df1)

#funciones útiles para dataframes
mtcars
head(mtcars, 5)
tail(mtcars)
str(mtcars) #MUY ÚTIL!!

#LISTAS
#estructura de dato más alta en la jerarquía de R
#puede contener variables, vectores, matrices, factores, dataframes (y listas -> listas anidadas)

l1 = list(v1, m1, f1, df1)
print(l1)
class(l1)
str(l1)
str(l1, max.level = 1)

#lista con nombres
l2 = list('name1' = v1,
          'name2' = m1,
          'name3' = f1,
          'name4' = df1)
names(l2)
str(l2, max.level = 1)

l2 = list(v1,m1,f1,df1)
str(l2, max.level = 1)
names(l2) = c('name1', 'name2', 'name3', 'name4')
str(l2, max.level = 1)

#obs: 
#los dataframes funcionan como listas en donde sus elementos son vectores!

####################################################
############### Logical comparision ################
####################################################

T & F #and
T | F #or

#VARIABLES
x
x > 1 #x >= 1
x == 1
x != 1
!(x == 1)

#VECTORES
v1
v1 > 3 
!(v1 > 3)
v1 %in% c(2,3)

#MATRICES
m1
m1 > 3
!(m1 > 3)
m1 %in% c(2,3)

####################################################
############### Select & Slice Data ################
####################################################

#VECTORES
v1
v1[2]
v1[-2] #todo menos
v1[0] #R comienza a indexar desde 1 (a diferencia de python, por ejemplo)
v1[c(1,6)]
v1[c(1:3)] # == v1[1:3]
v1[-c(1:3)] #todo menos

#por comparación (MUY ÚTIL!!)
#en general, sirve cualquier máscara de booleanos
v1[v1>2]
v1[!(v1>2)]
v1[v1 %in% c(2,3)]
v1[!(v1 %in% c(2,3))]

#por nombre componente
names(v1)
names(v1) = paste('n', seq(1,length(v1)), sep = '')
print(v1)
v1[c('n1', 'n3')] 

#retorna valores de un vector 'x' por condición de vector 'y' 
#OJO 'x' e 'y' mismo tamaño
names(v1)[v1>2]
v1[names(v1) == 'n3']

#MATRICES
print(m1)
m1[2,1] #elemento i,j de la matriz
m1[2:5, 4] #vector
m1[2:5, 1:4] #(sub)matriz
m1[30] #idx de 1 a length(m1)

#También se puede por comparación
#pero pierde la 'estructura de matriz' -> vector
m1[m1>3]
m1[m1 %in% c(2,5)]

#DATAFRAMES
#igual que matrices, pero además por nombre de columnas
mtcars[1:5, c('cyl', 'wt')]
mtcars[5,] #fila completa

#por posición de columna
mtcars[4]
class(mtcars[4])
mtcars[,4]
class(mtcars[,4])

#por nombre de columna
mtcars['wt']
class(mtcars['wt'])

mtcars$wt
class(mtcars$wt)


#por condición en alguna(s) variable
mtcars[(mtcars$cyl == 8),]
mtcars[(mtcars$cyl == 8 & mtcars$mpg > 15),]
#obs: más adelante veremos como filtrar dataframes de mejor manera

#LISTAS
l2[1]
class(l2[1])

l2[[1]]
class(l2[[1]])
l2$name1
#obs: [[ ]] y $ son equivalentes

l2[1:3]

#selección anidada
l2[[4]]
l2[[4]]['col1']
l2[[4]][['col1']]
l2$name4$col1
#obs: tener bien clara la diferencia entre [] con [[]] 
#--> También aplica en dataframes

####################################################
############## Conditional statements ##############
####################################################

#IF
condition = T
if (condition) {
  print('La condición se cumple')
}

#IF-ELSE
condition = (3 == 5)
if (condition) {
  print('La condición se cumple')
} else {
  print('La condición NO se cumple')
}

#IF-ELIF-ELSE
q_flow = 40
if (q_flow > 100) {
  print('nº mayor a 100')
} else if (q_flow < 100 & q_flow > 20) {
  print('nº menor a 100 y mayor a 20')
} else {
  print('nº menor a 20')
}

#OJO CON VECTORES
condition = v1 > 3
condition
if (condition) {
  print('La condición se cumple')
}

#SOLUCIÓN:
any(condition) #'or' a todos los componentes
all(condition) #'and' a todos los componentes

####################################################
###################### Loops #######################
####################################################

#WHILE
contador = 0
while (contador < 5) {
  print(contador)
  contador = contador+1
}

#break
contador = 0
while (T) {
  print(contador)
  contador = contador+1
  if (contador == 5){
    break
  }
}

#next
contador = 0
while (T) {
  if (contador == 2) {
    contador = contador+1 #IMPORTANTE PARA SALIR DEL LOOP
    next
  }
  print(contador)
  contador = contador+1
  if (contador == 5){
    break
  }
}

#FOR
#utilizado para iterar sobre, principalmente, vectores
for (var in 1:5) {
  print(var)
}

var_values = c('str1', 'str2', 'str3')
for (var in var_values) {
  print(paste('El valor de var es:', var))
}

#break y next también se pueden utilizar
#(se puede utilizar break con for pero es raro hacerlo)
for (var in 1:10) {
  if (var == 2){
    next
  }
  print(var)
  if (var == 5){
    break
  }
}

#REPEAT
#equivalente a while(True) -> DEBE ser utilizado con un 'break'
contador = 0
repeat {
  if (contador == 2) {
    contador = contador+1 #IMPORTANTE PARA SALIR DEL LOOP
    next
  }
  print(contador)
  contador = contador+1
  if (contador == 5){
    break
  }
}

#obs: se pueden usar loops dentro de loops (nested)
#combinando los 3 tipos (while-for-repeat) 

####################################################
#################### Packages ######################
####################################################

#importar paquetes: library() - require()
library(dplyr)
package_is_in = require(dplyr)
print(package_is_in)

library(PaqueteNoExistente)
package_is_in = require(PaqueteNoExistente)
print(package_is_in)

#instalar paquetes
package_name = 'dplyr'
install.packages(package_name) 

#lista de paquetes instalados
installed.packages()
class(installed.packages())
rownames(installed.packages())
package_name %in% rownames(installed.packages())

####################################################
################### Utilities ######################
####################################################

str(mtcars)
class(read.csv)
args(read.csv)
help(read.csv)
#?read.csv
?dplyr

paste('Primera parte del str', 'segunda parte del str', sep = ', ') #paste0 == paste(sep = '')

u1 = 2
u2 = 4
#mala forma
paste('El primer número es:', u1, 'y el segundo es:', u2)

#buena forma
sprintf('El primer número es: %s y el segundo es: %s', u1, u2)


