# 01 - Hello World

En este ejercicio partimos de una app creada con la tool `create-elm-app` y vamos a ir deshaciendo todo lo que esta tool agregó hasta dejar solo un `Hello World` para respetar la tradición a la hora de aprender un lenguaje nuevo. Spoiler: El verdadero objetivo de este ejercicio es interactuar con el compilador de Elm.

## 1 - Estructura de la applicación.

Revisemos un poco el código que genera `create-elm-app`. Abrí con tu editor el siguiente directorio:

- `01-hello-world/app`

### elm-stuff

Dentro de este directorio se encuentran las dependencias (otros packages de Elm) que utiliza nuestro proyecto, instaladas con `elm-package`. Si venís del mundo de JS, podes pensar en esta carpeta como el "node_modules" de Elm.

### public

Los archivos estáticos que van a usarse durante la compilación están dentro del directorio `public`. Ahí por ejemplo vas a encontrar el `index.html` que en general solo tiene un `div` con un id `root` que es donde va a embeberse nuestra aplicación Elm una vez compilada.

### src

Todo el código de nuestra aplicación se encuentra dentro de la carpera `src`. Ahí vas a ver tres archivos inicialmente, un archivo '.js', un archivo `.css` y un archivo `.elm`. Abrí el archivo JS y trata de entender el contenido. Ese archivo es el punto de entrada de la aplicación web. Lo único que hace es importar el archivo principal de Elm y embeber la aplicación de Elm en el `div` `root`.


 ## 2 - Borrando código

 La consigna es simple, abrimos el archivo `Main.elm` y empezamos a borrar todo lo que esté dentro del los comments `Model`, `Update` y `View`. Ya veremos más adelante qué son esas cosas. Guardamos el archivo y vemos qué pasa.

 El archivo debería quedar con este contenido:

 ```elm
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

Si el IDE está bien configurado, deberías ver un subrayado rojo en las palabras `Model`, `Msg`, `view`, `init` y `update`. Si vamos al navegador vamos a ver un mensaje de error del compilador: `Failed to compile`. Tomate un tiempo para leer el mensaje. 

Vemos que efectivamente nos dice que hay variables que estamos usando que no están definidas: las acabamos de borrar! pero nosotros no las necesitamos, solo queremos mostrar un `hello world`, así que modificá el código de forma que quede con el siguiente contenido:

 ```elm
module Main exposing (..)

import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src)


---- PROGRAM ----


main : Program Never Model Msg
main =
  "Hello World"
```

El error de compilación cambió, aún hay variables que que no existen. En este punto podemos mencionar que `main` es el punto de entrada de una aplicación Elm. No vamos a decir aún qué es `main`, pero podemos ver que en nuestro código se encuentra presente en dos lugares, en una asignación, donde pusimos ingenuamente nuestro `"Hello World"`, y sobre la asignación se encuentra lo que se conoce como `Type Annotation`, que sirve para decirle al compilador, de qué `type` es `main`. Pero qué es `Program Never Model Msg`? Aún no lo sabemos, pero qué tal si dejamos que el compilador se de cuenta de qué `type` es `main`?
Seguimos borrando código, borremos ahora la línea de la type anotation de forma que el código quede así:


```elm
module Main exposing (..)

import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src)


---- PROGRAM ----

main =
  "Hello World"
```

El compilador aún no está feliz! leamos cuidadosamente el mensaje de error. Los mensajes de error los podemos ver en el IDE, (parándonos con el cursor del mouse en las líneas subrayadas), en la consola, o en el navegador. Si miramos en la consola vamos a ver que están separados en `Warnings` y `Errors`. Tenemos 3 warnings. Vamos a resolver primero los warnings. Los warnings son alertas sobre malas prácticas o problemas en nuestro código que no afectan a la compilación, pero siempre está bueno resolverlos.

Tenemos 2 `unused import`. Estamos importando módulos que después no usamos.

```
-- unused import - ejercicios/01-hello-world/app/src/Main.elm

Module `Html` is unused.

3| import Html exposing (Html, div, img, text)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Best to remove it. Don't save code quality for later!
```

```
-- unused import - ejercicios/01-hello-world/app/src/Main.elm

Module `Html.Attributes` is unused.

4| import Html.Attributes exposing (src)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Best to remove it. Don't save code quality for later!
```

Nos dice la línea en la que ocurren y la acción recomendada (remover los imports). Removamos los imports de esas líneas.

Tenemos también 1 `missing type annotation` en la linea 10

```
-- missing type annotation - ejercicios/01-hello-world/app/src/Main.elm

Top-level value `main` does not have a type annotation.

10| main =
    ^^^^
I inferred the type annotation so you can copy it into your code:

main : String
```

No es obligatorio anotar los types en Elm, ya que el compilador los puede inferir, sin embargo se considera una buena práctica, ya que es una buena guía para otros programadores. Leamos la sugerencia, el compilador nos está diciendo de qué tipo es `main` y nos está dando la línea para copiar y pegar! Hagámoslo. El código debería haber quedado así:

```elm
module Main exposing (..)

---- PROGRAM ----

main : String
main =
  "Hello World"
```

Veamos qué dice el compilador ahora. Los warnigs desaparecieron y tenemos el siguiente mensaje de error:

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

Literalmente, lo que nos dice el compilador es que el type de `main` es incorrecto, necesita elgo que sea de type `Html`, `Svg` o `Program` y le estamos dando un `String`. Nosotros queremos mostrar un mensaje, pero resulta que el navegador muestra siempre el texto adentro de un nodo de `Html`, un nodo que precisamente se llama `text`, y es el nodo mas básico del DOM. La forma más fácil entonces de lograr nuestro objetivo es usar el modulo `Html` (sí, ese que acabamos de borrar!) para construir algo de tipo `Html`. El módulo `Html` expone una función para cada tipo de nodo del dom (`div`, `img`, etc). nosotros necesitamos solo `text`. Modifica el código de la sigueinte forma:

```elm
module Main exposing (..)

import Html exposing (text)

---- PROGRAM ----

main =
  text "Hello World"
```

Et voila! El programa funciona y muestra nuestro texto "Hello World!". Un detalle, nos está faltando corregir un último warning! Cuál es el type de `main` ahora?
