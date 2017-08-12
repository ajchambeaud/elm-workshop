# 01 - Hello World

Este ejercicio partimos de una app creada con la tool `create-elm-app` y vamos a ir deshaciendo todo lo que esta tool agrego hasta dejar solo un `Hello World` para respetar la tradición a la hora de aprender un lenguaje nuevo. Spoiler: El verdadero objetivo de este ejercicio es interactuar con el compilador de Elm.

## 1 - Estructura de la applicación.

Revisemos un poco el codigo que genera `create-elm-app`. Abri con tu editor el siguiente directorio:

- `01-hello-world/app`

### elm-stuff

Dentro de este directorio se encuentran las dependencias (otros packages de Elm) que utiliza nuestro proyecto, instaladas con `elm-package`. Si venis del mundo de JS, podes pensar en esta carpeta como el "node_modules" de Elm.

### public

Los archivos estaticos que van a usarse durante la compilacion estan dentro del directorio `public`. Ahi por ejemplo vas a encontrar el `index.html` que en general solo tiene un `div` con un id `root` que es donde va a embeberse nuestra aplicacion Elm una vez compilada.

### src

Todo el codigo de nuestra applicacion se encuentra dentro de la carpera `src`. Ahi vas a ver tres archivos inicialmente, un archivo '.js', un archivo `.css` y un archivo `.elm`. Abri el archivo JS y trata de entender el contenido. Ese archivo es el punto de entrada de la aplicacion web. Lo unico que hace es importar el archivo principal de Elm y embeber la aplicacion de Elm en el div root.


 ## 2 - Borrando coódigo

 La consigna es simple, abrimos el archivo `Main.elm` y empezamos a borrar todo lo que este dentro del los comments Model, Update y View. Ya veremos mas adelante que son esas cosas. Guardamos el archivo y vemos que pasa.

 El archivo deberia quedar con este contenido:

 ```
 module Main exposing (..)

import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src)


---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
```

Si el IDE esta bien configurado, deberias ver un subrayado rojo en las palabras `Model`, `Msg`, `view`, `init` y `update`. Si vamos al navegador vamos a ver un mensaje de error del compilador: `Failed to compile`. Tomate un tiempo para leer el mensaje. 

Vemos que efectivamente nos dice que hay variables que estamos usando que no estan definidas: las acabamos de borrar! pero nosotros no las necesitamos, solo queremos mostrar un hello world, asique modifica el codigo de forma que quede con el siguiente contenido:

 ```
module Main exposing (..)

import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src)


---- PROGRAM ----


main : Program Never Model Msg
main =
  "Hello World"
```

El error de compilacion cambio, aun hay variables que que no existen. A este punto podemos mencionar que `main` es el punto de entrada de una aplicacion Elm. No vamos a decir aun que es main, pero podemos ver que en nuestro codigo se encuentra presente en dos lugares, en una asignacion, donde pusimos ingenuamente nuestro "Hello World", y sobre la asignacion se encuentra lo que se conoce como `Type Annotation`, que sirve para decirle al compilador, de que `type` es main. Pero que es `Program Never Model Msg`? Aun no lo sabemos, pero que tal si dejamos que el compilador se de cuenta de que type es main?
Seguimos borrando codigo, borremos ahora la linea de la type anitation de forma que el codego quede asi:


```
module Main exposing (..)

import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src)


---- PROGRAM ----

main =
  "Hello World"
```

El compilador aun no esta feliz! leamos cuidadosamente el mensaje de error. Los mensajes de error los podemos ver en el IDE, (parandonos con el cursor del mouse en las lineas subrayadas). En la consola, o en el navegador. Si miramos en la consola vamos a ver que estan separados en Warning y Errors. Tenemos 3 Warnings. Vamos a resolver primero los warnings. Los warnings son alertas sobre malas practicas o problemas en nuestro codigo que no afectan a la compilacion, pero siempre esta bueno resolverlos.

Tenemos 2 `unused import`. Estamos importando modulos que despues no usamos.

```-- unused import - ejercicios/01-hello-world/app/src/Main.elm

Module `Html` is unused.

3| import Html exposing (Html, div, img, text)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Best to remove it. Don't save code quality for later!```

```
-- unused import - ejercicios/01-hello-world/app/src/Main.elm

Module `Html.Attributes` is unused.

4| import Html.Attributes exposing (src)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Best to remove it. Don't save code quality for later!
```

Nos dice la lina en la que ocurren y la accion recomendada (remover los imports). Removamos los imports de esas lineas.

Tenemos tambien 1 `missing type annotation` en la linea 10

```
-- missing type annotation - ejercicios/01-hello-world/app/src/Main.elm

Top-level value `main` does not have a type annotation.

10| main =
    ^^^^
I inferred the type annotation so you can copy it into your code:

main : String
```

No es obligatorio anotar los types en Elm, ya que el compilador los puede inferir, sin embargo se considera una buena practica, ya que es una buena guia para otros programadores. Leamos la sugerencia, el compilador nos esta diciendo de que tipo es main y nos esta dando la linea para copiar y pegar! Hagamoslo. El codigo deberia haber quedado asi:

```
module Main exposing (..)

---- PROGRAM ----

main : String
main =
  "Hello World"
```

Veamos que dice el compilador ahora. Los warnigs desaparecieron y tenemos el siguiente mensaje de error:

```
-- BAD MAIN TYPE - ejercicios/01-hello-world/app/src/Main.elm

The `main` value has an unsupported type.

7| main =
   ^^^^
I need Html, Svg, or a Program so I have something to render on screen, but you
gave me:

    String

Detected errors in 1 module.
```

Literalmente, lo que nos dice el compilador es que el type de main es incorrecto, necesita elgo que sea de type `Html`, `Svg` o `Program` y le estamos dando un String. Nosotros queremos mostrar un mensaje, pero resulta que el navegador muestra siempre el texto adentro de un nodo de Html, un nodo que presisamente se llama text, y es el nodo mas basico del DOM. La forma mas facil entonces de lograr nuestro objetivo es usar el modulo Html (si, ese que acabamos de borrar!) para construir algo de tipo Html. Elm modulo Html expone una funcion para cada tipo de nodo del dom (`div`, `img`, etc). nosotros necesitamos solo `text`. Modifica el codigo de la sigueinte forma:

```
module Main exposing (..)

import Html exposing (text)

---- PROGRAM ----

main =
  text "Hello World"
```

Et voila! El programa funciona y muestra nuestro texto "Hello World!". Un detalle, nos esta faltando corregir un ultimo warning! Cual es el type de `main` ahora?