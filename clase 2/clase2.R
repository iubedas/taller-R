
#' @author: iubeda
#' Functions - Optimization

####################################################
############## Intro. to Functions #################
####################################################

#Funciones son útiles para modularizar código (permite no repetir bloques de código ('code chunks'))
#Se componen de 3 cosas: argumentos, cuerpo y ambiente
#IMPORTANTE: dar 'buenos nombres' a nuestras funciones, argumentos y, en lo posible, DOCUMENTAR! 
#Estructura:
my_function = function(arg1, arg2) {
  #' Brief description.
  #' 
  #' @param arg1 Argument 1 description.
  #' @param arg2 Argument 2 description.
  #' @return 
  #' @examples
  #'
  
  function_body
}

#Ej:
add = function(x, y) {
  print(sprintf('x = %s, y = %s. Suma = %s', x, y, x+y))
}

add(3,5) #match por posición
add(x=3, y=5) #match por nombre

add(y=5, x=3)
add(5, 3)

#Podemos hacer que retornen valores
add = function(x, y) { 
  print(sprintf('x = %s, y = %s. Suma = %s', x, y, x+y))
  return(x+y)
}

suma = add(3,5)
print(suma)

#OJO: no es necesario utilizar return()
#R entiende que la última línea de la función corresponde al return()
#(pero hace más legible el código)
add_2 = function(x, y) {
  print(sprintf('x = %s, y = %s. Suma = %s', x, y, x+y))
  x+y
}

suma2 = add_2(3,5)
print(suma2)

#Funciones son objetos en R (i.e. permiten ser asignados como una variable)
add_asigned = add
add_asigned(3,5)

#'Online' functions ('lambda') #ÚTILES PARA APPLY
function(x,y) {x+y}
(function(x,y) {x+y})(3,5)

####################################################
################# Environments #####################
####################################################

#Si alguna variable no está definida dentro de la función, 
#R lo buscará un nivel más alto en la jerarquía

x = 3
add_global = function(y) {
  print(sprintf('x = %s, y = %s. Suma = %s', x, y, x+y))
  return(x+y)
}

add_global(5)
add(4,5)
print(x)
print(y)

x = 4
add_global(5)
add(3,5)
print(x)


#cambiar variables globales dentro de una función
x = 4
change_x = function(y) {
  x = x + y
}

print(x)
change_x(5)
print(x)

#Obs: R no tiene punteros dentro del ambiente de la función a variables globales. 
#SOLUCIÓN: 'assign'
args(assign)

change_x = function(y) {
  assign('x',x+y,envir=.GlobalEnv)
}

print(x)
change_x(5)
print(x)

#assign permite también cambiar más de una variable a la vez
x = 4
z = 2
change_both = function(y) {
  assign('x',x+y,envir=.GlobalEnv)
  assign('z',z+y,envir=.GlobalEnv)
}

print(x)
print(z)
change_both(10)
print(x)
print(z)

#ambiente global
x = 4
env = globalenv()
ls(env) #lista de objetos en ambiente global
class(env)
print(env$x) # == get('x', envir= .GlobalEnv)
print(x)

#definir nuevos ambientes
my_env = new.env()
ls(my_env)
assign("x", 1000, envir=my_env)
ls(my_env)
print(my_env$x) # == get('x', envir= my_env)
print(x)

#asignar ambientes a funciones
print(x)
add_global(5)
environment(add_global)
environment(add_global) = my_env
environment(add_global)
add_global(5)

#volver a ambiente global
environment(add_global) = globalenv()
add_global(5)

#más info:
#https://www.r-bloggers.com/environments-in-r/

####################################################
############### Parameters Type ####################
####################################################

#Default arguments 
add = function(x, y = 5) { 
  print(sprintf('x = %s, y = %s. Suma = %s', x, y, x+y))
  return(x+y)
}

add(3,5)
add(3)
add()

#Solución 1:
add = function(x = 3, y = 5) { 
  print(sprintf('x = %s, y = %s. Suma = %s', x, y, x+y))
  return(x+y)
}

add(3,5)
add(3)
add()
add(5)

#Solución 2: Missing arguments -> missing()
add = function(x, y = 5) { 
  if(missing(x)) {
    print('missing x value, 3 assigned')
    x = 3
  } else {
    print(sprintf('x = %s, y = %s. Suma = %s', x, y, x+y))
  }
  
  return(x+y)
}

add()

#'Mapear' argumentos de una sola vez -> do.call()
args <- list(x = 3, y = 5)
do.call(add,args)

####################################################
################# Apply Family #####################
####################################################

add = function(x, y = 5, verbose = F) { 
  if (verbose){
    print(sprintf('x = %s, y = %s. Suma = %s', x, y, x+y))
  }
  return(x+y)
}

#PROPÓSITO: 
#aplicar funcion iterativamente sin tener que usar un loop explícito

#apply: apply function over array
args(apply)

mtcars
sum(mtcars)
apply(mtcars, 1, sum) #byrow 
rowSums(mtcars)

apply(mtcars, 2, sum) #bycol 
colSums(mtcars)

#lapply: apply function over list or vector -> return list
args(lapply)

x_list = list(1, 2, 3, 4) 
str(x_list)
x_vector = c(1,2,3,4)
str(x_vector)

args(add)
add_list = lapply(x_list, add)
str(add_list)

add_list = lapply(x_vector, add)
str(add_list)

#cambiar '...' por parámetros de FUN
args(lapply)
add_list = lapply(x_list, add, y = 10, verbose = T)
str(add_list)

#sapply: apply function over list or vector 
#-> return vector (simplify list to array)
args(sapply)

add_vector = sapply(x_list, add)
str(add_vector)

add_vector = sapply(x_vector, add)
str(add_vector)

add_vector = sapply(x_vector, add, simplify = F) # <=> lapply
str(add_vector)

#cambiar '...' por parámetros de FUN
add_vector = sapply(x_list, add, y = 10, verbose = T)
str(add_vector)

#vapply: apply function over list or vector 
#-> return format explicitly specified
args(vapply)
vapply(x_list, add, numeric(1))
vapply(x_list, add, character(1))

#mapply: apply a function to multiple list or vector arguments
args(mapply)

add_multiple = mapply(add, x = c(1:10), y = (1:10)) 
str(add_multiple)

add_multiple = mapply(add, x = c(1:10), y = (1:10), SIMPLIFY = F) 
str(add_multiple)

#hay más tipos: rapply, tapply
#más info (MUY BUENO!):
#https://www.datacamp.com/community/tutorials/r-tutorial-apply-family

#'online' function with apply family
#Ej
sqr_list = lapply(x_list, function(x) {x^2})
str(sqr_list)

sqr_list = lapply(x_list, function(x,y) {x^2 + y}, y = 10)
str(sqr_list)

#APLICACIÓN
summary(mtcars)
class(summary(mtcars))
summary(mtcars)[1,2]

my_summary = function(x) {
  list('min' = min(x),
      '1st Qu.' = quantile(x)['25%'],
      'mean' = mean(x),
      'median' = median(x),
      'std' = sd(x),
      '3rd Qu.' = quantile(x)['75%'],
      'max' = max(x))
}

summary_list = lapply(mtcars, my_summary) # == apply(mtcars, 2, my_summary)
str(summary_list, max.level = 1)

str(summary_list$mpg)
print(summary_list$mpg$std)
print(summary_list$cyl$std)
print(summary_list$disp$std)

#seleccionar estadística en particular: 
select_stat = function(l, stat_name) {l[[stat_name]]}

str(summary_list, max.level = 1)
sapply(summary_list, select_stat, stat_name = 'mean')
sapply(summary_list, select_stat, stat_name = 'std')

####################################################
########## General purpose optimization ############
####################################################

#one-dimension optimization: R -> R
parabola = function(x, a = 1, b = 2, c = 10) {a*x^2 + b*x + c}

#minimización
x = seq(-15, 15, by = 0.01)
y = parabola(x) # == mapply(parabola, x) (¡CASO PARTICULAR!)
plot(x,y)

#optim function documentation:
#https://stat.ethz.ch/R-manual/R-devel/library/stats/html/optim.html
args(optim)

result = optim(0, parabola)
str(result)

result = optim(0, parabola, method = 'Brent')
result = optim(0, parabola, method = 'Brent', lower = -1e10, upper = 1e10)
str(result)
result$convergence == 0 #convergencia

if (result$convergence == 0) {
  print(result$par)
  abline(v = result$par, col = 'red')
} else {
  print('No hubo convergencia')
}

#maximización
y = parabola(x, a = -1, b = 5)
plot(x,y)

result = optim(0, parabola, method = 'Brent', lower = -1e10, upper = 1e10)
str(result)

if (result$convergence == 0) {
  print(result$par)
  abline(v = result$par, col = 'red')
} else {
  print('No hubo convergencia')
}

#Obs: Se deben pasar los argumentos de 'fn' a 'optim' también

plot(x,y)
result = optim(0, parabola, a = -1, b = 5, 
               method = 'Brent', lower = -1e10, upper = 1e10)
str(result)

if (result$convergence == 0) { 
  print(result$par)
  abline(v = result$par, col = 'red')
} else {
  print('No hubo convergencia')
}

#Obs: optim() minimiza por default
#Para maximizar debemos crear la función negativa

parabola_neg = function(x, a = 1, b = 2, c = 4) {-parabola(x,a,b,c)}

result = optim(0, parabola_neg, a = -1, b = 5, 
               method = 'Brent', lower = -1e10, upper = 1e10)
str(result)
if (result$convergence == 0) {
  print(result$par)
  abline(v = result$par, col = 'red')
} else {
  print('No hubo convergencia')
}

#n-dimension optimization: R^n -> R
paraboloide = function(x, y, a = 3, b = 5) {z = (x+a)^2 + (y+b)^2}

x = seq(-15, 15, by = 0.5)
y = seq(-15, 15, by = 0.5)

args(outer)
z = outer(X = x, 
          Y = y, 
          paraboloide)

class(z)

#3D surface
persp(x = x, y = y, z = z)

#clear plots
dev.off()

#NECESARIO PARA UTILIZAR OPTIM!!
paraboloide_vectorized = function(param) {
  paraboloide(param[1], param[2])
}

result = optim(c(0,0), paraboloide_vectorized)
str(result)

if (result$convergence == 0) {
  print(result$par)
} else {
  print('No hubo convergencia')
}

####################################################
################ Linear programming ################
####################################################

#lpSolve package:
#https://cran.r-project.org/web/packages/lpSolve/lpSolve.pdf

library(lpSolve)
args(lp)

#Ej. 1 - LP:
#LP example 1994 UG exam from http://people.brunel.ac.uk/~mastjjb/jeb/or/morelp.html
#
# max 20x + 30y - 10(13x + 19y)/60 - 2(20x + 29y)/60
# i.e. max 17.1667x + 25.8667y
# 
# subject to:
#   
# 13x + 19y <= 2400
# 20x + 29y <= 2100
# x >= 10
# x,y >= 0
#
#solution: x=10, y=65.52 with the value of the objective function being 1866.5

f.obj = c(17.1667, 25.8667)
f.con = matrix (c(13, 19, 20, 29, 1, 0, 1, 1), ncol=2, byrow=TRUE)
print(f.con)
f.dir = c("<=", "<=", '>=', '>=')
f.rhs = c(2400, 2100, 10, 0)

result = lp("max", f.obj, f.con, f.dir, f.rhs)

class(result)
str(result)

#recuperar valores de interés:
result$x.count #nº variables
result$status #0 = succes, 2 = no feasible solution
result$int.count #nª variables enteras (MILP)
result$objval #función objetivo optimizada
result$solution #valores óptimos de parámetros

rm(result) #remove from global environment

#Ej. 2 (MILP):
#MILP example from https://www.cs.upc.edu/~erodri/webpage/cps/theory/lp/milp/slides.pdf
#
# max x + y 
# 
# subject to:
#   
# −2x + 2y ≥ 1 
# −8x + 10y ≤ 13
# x, y ≥ 0
# x, y ∈ Z
#
#solution: x=1, y=2 with the value of the objective function being 3

f.obj = c(1, 1)
f.con = matrix (c(-2, 2, -8, 10, 1, 1), ncol=2, byrow=TRUE)
print(f.con)
f.dir = c(">=", "<=", '>=')
f.rhs = c(1, 13, 0)
f.int_vector = c(1,2)  #indice de variables enteras

result = lp("max", f.obj, f.con, f.dir, f.rhs, int.vec = f.int_vector)
result$status 
result$int.count 
result$objval 
result$solution 
rm(result)

#mismo resultado si es que todas las variables son enteras
result = lp("max", f.obj, f.con, f.dir, f.rhs, all.int = T)
result$status 
result$int.count 
result$objval 
result$solution 
rm(result)

#Para variables binarias es similar: 'binary.vec' y 'all.bin'
args(lp)

#supongamos que ahora 'y' es una variable binaria en el mismo ejemplo anterior.

result = lp("max", f.obj, f.con, f.dir, f.rhs, binary.vec = c(2))
result$status 
result$int.count 
result$objval 
result$solution 
rm(result)

