# 03 - Elm Architecture

## Entendiendo la arquitectura de Elm

En este ejercicio vamos a empezar a explorar una de las principales características que volvieron popular a Elm como plataforma para hacer apps frontend: La Elm Architecture.

Si abrimos el archivo `app/Main.elm` vamos a ver que el mismo se encuentra dividido en distintas secciones por comentarios. Vamos hacia el final del archivo:


```elm
---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = model
        , update = update
        }
```

Vemos que ahora `main` en lugar de ser de tipo `Html msg` como en los ejercicios anteriores, es de tipo `Program Never Model Msg`. Digamos por ahora que es de tipo `Program` y olvidemos de momento todo lo demás. Los ejemplos anteriores eran estáticos, en el sentido de que no tenían ningún tipo de interacción con el usuario. `Program` es una estructura de datos que tiene información adicional para el runtime de Elm además de lo necesario para "mostrar algo en pantalla". Un `Program` describe cómo funciona tu aplicación. Para entender el resto de la type annotation es necesario saber conocer un poco más la arquitectura de Elm. Pasemos primero a ver cómo creamos un programa y dejemos para más adelante los detalles del type:

```elm
Html.beginnerProgram
    { view = view
    , model = model
    , update = update
    }
```

Estamos usando la funcion `beginnerProgram` que crea una versión básica de la Elm Architecture. La función recibe un único parametro, que es un record con tres partes, las tres partes básicas de esta arquitectura: `model`, `view` y `update`.

### Model

Model es la estructura de datos que representa el estado de tu aplicación. Busquemos el código de `model` más arriba en el código de la app.

```elm
---- MODEL ----


type alias Model =
    {}


model : Model
model =
    {}
```

Así como está, lo que el cádigo representa es: se define un type alias con el identificador `Model` que representa un record sin campos. Se inicializa una variable `model` de tipo `Model` con un record vacío. Evidentemente un record vacío no resulta muy útil para definir el estado de una aplicación. Lo primero que hacemos al diseñar una app en Elm es definir cómo se vería este modelo. Qué información queremos representar y cuál es la mejor forma de representarla. Una vez que definimos el `type` del modelo creamos una instancia que representa el estado inicial del mismo. Esta instancia es lo que nos pide el programa Elm, junto con el type que es uno de los 'parámetros' que le pasamos a 'Program'. De este modo el runtime de Elm ya sabe qué tipo de datos maneja tu aplicación y cuál es su estado inicial.


### View

Una vez que ya sabemos qué tipo información maneja nuestra app y como la vamos a representar, el siguiente paso es definir la capa de presentación. La vista en Elm se representa como una función pura del modelo. Es decir, tenemos que definir una función `view` que reciba el modelo y devuelva algo de tipo `Html Msg`. Veamos el código que genera create-elm-app por nosotros para la parte de la vista.


```elm
---- VIEW ----


view : Model -> Html Msg
view model =
    div
        []
        [ text "Lets make a counter!" ]
```

Como ya estuvimos trabajando con funciones que devuelven `Html`, esta función no debería resultarte difícil de entender. En este caso la función recibe el modelo y devuelve una representación del DOM. Sin embargo, hay un detalle visible para los más observadores. Si miramos la type annotation del código de arriba, es ligeramente distinta a la de las funciones que veniamos haciendo. Esta función `view` devuelve algo de tipo `Html Msg` mientras que las anteriores devuelven algo de tipo `Html msg`. `msg` (escrito con minúscula) es una `type variable`. Todos los types en Elm se escriben con mayúscula. Las type variables sirven para escribir código genérico y varias de las funciones del módulo core las usan. El uso de type variables está fuera del scope del workshop, pero la información relevante para nosotros es que al type `Html` le estamos agregando un type que definimos nosotros: `Msg`. `Msg` no es una palabra reservada, podríamos ponerle cualquier otro nombre al type pero es una convención en Elm usar `Msg`. Basta de misterio! qué significa `Msg` (`msg`)!? Básicamente quiere decir que la función `view` devuelve una representación de `Html` que "es capaz" de generar mensages de tipo `Msg`. Si esta explicación no te convence, pasemos a la última pieza de la arquitectura Elm: La funcion `update`.


### Update

Ya sabemos qué estructura tiene el state de nuestra aplicacion (`model`) y ya sabemos cómo se va a representar esa información (`view`). Para tener un programa funcional sin embargo, nos falta una última pieza de información: cómo se transforma el estado. Si el estado de la aplicación nunca cambia la aplicación no tendría ningun tipo de interacción con el mundo exterior. La función `update` representa el modo en el que el modelo se trasforma como respuesta a interacciones del usuario. Veamos el código de la función `update` generada:


```elm
---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    model

```

En las primeras líneas definimos el type `Msg`. `Msg` generalmente es un `union type` que representa todos los mensajes que el usuario puede generar interactuando con la vista de la aplicación. La única forma de modificar el estado de una aplicación Elm es generando un mensage de typo `Msg` (por ejemplo al interactuar con la vista). Cuando un mensaje es generado desde la vista, el mismo es recibido por el runtime de Elm, y este último llama a nuestra función `update`. La función `update` recibe este mensaje y el estado actual del modelo, y retorna el nuevo modelo.


## Ejemplo básico de programa interactivo: Un contador!

Un contador es el "Hola mundo" del frontend. Básicamente porque permite contestar todas las preguntas que toda arquitectura moderna debería poder contestar: Cómo es el state de tu programa? Cómo se ve tu programa? Qué cosas puede hacer el usuario? y Cómo se modifica el state como respuesta a esta interacción. Un contador muestra un número en pantalla y tiene dos botones, uno para incrementar el valor del contador y uno para decrementarlo.


### Cómo es el state de tu programa?

Empecemos definiendo el modelo. Vamos a hacer un contador por lo tanto solo necesitamos un número entero. Modificamos el modelo de esta forma:

```elm
type alias Model =
    { count : Int }
```

Nuestro record tiene un solo field `count` que mantiene la cuenta y es de tipo `Int`

```elm
model : Model
model =
    { count = 0 }
```

El valor inicial del modelo es un record con el field `count` inicializado en cero.


### Cómo se ve tu programa?

Nuestra función `view` entonces debería tener solamente un texto para mostrar el valor de `count` y dos botones. Reemplazá el código de la vista por:

```elm
view : Model -> Html Msg
view model =
    div
        [ class "counter" ]
        [ button [] [ text "+" ]
        , div [] [ text <| toString model.count ]
        , button [] [ text "-" ]
        ]
```

Nota: 

`text <| toString model.count` es equivalente a `text (toString model.count)`. El operador `<|` se usa para reducir el uso excesivo de parentesis. Básicamente indica "pasar" el resultado de la expresión de la derecha como parámetro a la función de la izquierda. El operador `|>` hace lo opuesto.


### Qué cosas puede hacer el usuario?

El usuario únicamente puede hacer click en alguno de los botones. Modifiquemos la definición de `Msg` para expresar las dos acciones que el usuario puede realizar.

```elm
type Msg
    = Increase
    | Decrease
```

Modifiquemos la función de la vista para que cuando el usuario haga click en los botones, en efecto se generen estos mensajes para el runtime de Elm.

```elm
view : Model -> Html Msg
view model =
    div
        [ class "counter" ]
        [ button [ onClick Increase ] [ text "+" ]
        , div [] [ text <| toString model.count ]
        , button [ onClick Decrease ] [ text "-" ]
        ]
```

### Cómo se modifica el state como respuesta a esta interacción?

Nos falta definir cómo afectan los mensajes generados por las acciones del usuario al state de la aplicación.  Para eso en la función `update` hacemos pattern matching sobre el valor del parámetro `msg`, que como es de tipo `Msg` sabemos que solo puede tomar dos valores: `Increase` y `Decrease`.

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase ->
            { model | count = model.count + 1 }

        Decrease ->
            { model | count = model.count - 1 }
```

Fijate cómo actualizamos el modelo: en Elm, todas las estructuras de datos son inmutables, por lo tanto no es posible modificar el valor de un record. Existe una sintaxis especial para obtener un record nuevo a partir de la modificación parcial del anterior: `{ model | count = model.count + 1 }`. Con esta línea estamos diciendo que queremos un record igual que `model`, pero que su field `count` sea tenga el valor `model.count + 1`. Como nuestro record tiene un solo field, esto no es necesario, y sería suficiente con devolver `{ count : model.count + 1 }`.

Ya tenemos nuestro primer programa funcionando!
