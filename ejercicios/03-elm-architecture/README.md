# 03 - Elm Architecture

## Entendiendo la arquitectura de Elm

En este ejercicio vamos a empezar a explorar una de las principales caracteristicas que volvieron popular a Elm como plataforma para hacer apps frontend: La Elm Architecture.

Si abrimos el archivo `app/Main.elm` vamos a ver que el mismo se encuentra dividido en distintas secciones por comentarios. Vamos hacia el final del archivo:


```
---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = model
        , update = update
        }
```

Vemos que ahora `main` en lugar de ser de tipo `Html msg` como en los ejercicios anteriores, es de tipo `Program Never Model Msg`. Digamos por ahora que es de tipo `Program` y olvidemos de momento todo lo demas. Los ejemplos anteriores eran estaticos, en el sentido de que no tenian ningun tipo de interacción con el usuario. `Program` es una estructura de datos que tiene informacion adicional para el runtime de Elm ademas de lo necesario para "mostrar algo en pantalla". Un `Program` describe como funciona tu applicación. Para entender el resto de la type anotation es necesario saber conocer un poco mas la arquitectura de Elm. Pasemos primero a ver como creamos un programa y dejemos para mas adelante los detalles del type:

```
Html.beginnerProgram
    { view = view
    , model = model
    , update = update
    }
```

Estamos usando la funcion `beginnerProgram` que crea una version basica de la Elm Architecture. La funcion recibe un unico parametro, que es un record con tres partes, las tres partes basicas de esta arquitectura: `model`, `view` y `update`.

### Model

Model es la estructura de datos que representa el estado de tu aplicacion. Busquemos el codigo de model mas arriba en el codigo de la app.

```
---- MODEL ----


type alias Model =
    {}


model : Model
model =
    {}
```

Asi como esta, lo que el codigo representa es: se define un type alias con el identificador `Modlel` que representa un record vacio. Se inicializa una variable model de tipo `Model` con un record vacio. Evidentemente un record vacio no resulta muy ultil para definir el estado de una applicacion. Lo primero que hacemos al diseñar una app en Elm es definir como se veria este modelo. Que información queremos representar y cual es la mejor forma de representarla. Una vez que definimos el `type` del modelo creamos una instancia que representa el estado inicial del mismo. Esta instancia es lo que nos pide el programa Elm, junto con el type que es uno de los 'parametros' que le pasamos a 'Program'. De este modo el runtime de Elm ya sabe que tipo de datos maneja tu aplicacion y cual es su estado inicial.


### View

Una vez que ya sabemos que tipo informacion maneja nuestra app y como la vamos a representar, el siguiente paso es definir la capa de presentación. La vista en Elm se representa como una funcion pura del modelo. Es decir, tenemos que definir una funcion `view` que recibe el modelo y devuelva algo de tipo `Html Msg`. Veamos el código que genera create-elm-app por nosotros para la parte de la vista.


```
---- VIEW ----


view : Model -> Html Msg
view model =
    div
        []
        [ text "Lets make a counter!" ]
```

Como ya estuvimos trabajando con funciones que devuelven Html, esta funcion no deberia resultarte dificil de entender. En este caso la funcion recibe el modelo y devuelve una representacion del dom. Sin embargo hay un detalle visible para los mas obervadores. Si miramos la type anotation del codigo de arriba, es ligeramente distinta a la de las funciones que veniamos haciendo. Esta funcion view devuelve algo de tipo `Html Msg` mientras que las anteriores devuelven algo de tipo `Html msg`. msg (escrito con minuscula) es una `type variable`. Todos los types en Elm se escriben con mayuscula. Las type variables sirven para escribir codigo generico y varias de las funciones del module core las usan. El uso de type variables esta fuera del scope del workshop, pero la informacion relevante para nosotros es que al type `Html` le estamos agregando un type que definimos nosotros: `Msg`. Msg no es una palabra reservada, podriamos ponerle cualquier otro nombre al type pero es una convencion en Elm usar `Msg`. Basta de misterio! que significa Msg (msg)!? Basicamente quiere decir que la funcion view devuelve una representacion de Html que "es capaz" de generar mensages de tipo `Msg`. Si esta explicacion no te convence, pasemos a la ultima pieza de la arquitectura Elm: La funcion 'update'.


### Update

Ya sabemos que estructura tiene el state de nuestra aplicacion (model) y ya sabemos como se va a representar esa informacion (view). Para tener un programa funcional sin embargo, nos falta una ultima pieza de informacion: coómo se transforma el estado. Si el estado de la aplicacion nunca cambia la aplicacion no tendria ningun tipo de interaccion con el mundo exterior. La funcion update representa el modo en el que el modelo se trasforma como respuesta a interacciones de usuario. Veamos el codigo de la funcion update generada:


```
---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    model

```

En las primeras lineas definimos el type `Msg`. Msg generalmente es un `union type` que representa todos los mensajes que el usuario puede generar interactuando con la vista de la applicacion. La unica forma de modificar el estado de una applicacion Elm es generando un mensage de typo Msg (por ejemplo al interactuar con la vista). Cuando un mensaje es generado desde la vista, el mismo es recibido por el runtime de Elm, y este ultimo llama a nuestra funcion `update`. La funcion update recibe este mensaje y el estado actual del modelo, y retorna el nuevo modelo.


## Ejemplo basico de programa interactivo: Un contador!

Un contador es el "Hola mundo" del frontend. Basicamente porque permite contestar todas las preguntas que toda arquitectura moderna deberia poder contestar: Como es el state de tu programa? Como se ve tu programa? Que cosas puede hacer el usuario? y Como se modifica el state como respuesta a esta interaccion. Un contador muetra un numero en pantalla y tiene dos buttons, uno para incrementar el valor del contador y uno para decrementarlo.


### Cómo es el state de tu programa?

Empecemos definiendo el modelo. Vamos a hacer un contador por lo tanto solo necesitamos un numero entero. Modificamos el modelo de esta forma:

```
type alias Model =
    { count : Int }
```

Nuestro record tiene un solo field `count` que mantiene la cuenta y es de tipo `Int`

```
model : Model
model =
    { count = 0 }
```

El valor inicial del modelo es un record con el field `count` inicializado en cero.


### Cómo se ve tu programa?

Nuestra funcion vista entonces deberia tener solamente un texto para mostrar el valor de `count` y dos buttons. Reemplaza el codigo de la vista por:

```
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

`text <| toString model.count` es equivalente a `text (toString model.count)`. El operador `<|` se usa para reducir el uso excesivo de parentecis. Basicamente indica "pasar" el resultado de la expresion de la derecha como parametro a la funcion de la izquierda. El operador `|>` hace lo opuesto.


### Qué cosas puede hacer el usuario?

El usuario unicamente puede hacer click en alguno de los botones. Modifiquemos la definicion de `Msg` para expresar las dos acciones que el usuario puede realizar.

```
type Msg
    = Increase
    | Decrease
```

Modifiquemos la funcion de la vista para que cuando el usuario haga click en los botones, en efecto se generen estos mensajes para el runtime de Elm.

```
view : Model -> Html Msg
view model =
    div
        [ class "counter" ]
        [ button [ onClick Increase ] [ text "+" ]
        , div [] [ text <| toString model.count ]
        , button [ onClick Decrease ] [ text "-" ]
        ]
```

### Como se modifica el state como respuesta a esta interaccion?

Nos falta definir como afectan los mensages generados por las acciones del usuario al state de la applicacion.  Para eso en la funcion `update` hacemos pattern maching sobre el valor del parametro `msg`. Que como es de tipo `Msg` sabemos que solo puede tomar dos valores: `Increase` y `Decrease`.

```
update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase ->
            { model | count = model.count + 1 }

        Decrease ->
            { model | count = model.count - 1 }
```

Fijate como actualizamos el modelo: en elm, todas las estructuras de datos son inmutables, por lo tanto no es posible modificar el valor de un record. Existe una sintaxis especial para obtener un record nuevo a partir de la modificacion parcial del anterior: `{ model | count = model.count + 1 }` con esta linea estamos diciendo que queremos un record igual que `model`, pero que si field `count` sea tenga el valor `model.count + 1`. Como nuestro record tiene un solo field, esto no es necesario, y seria suficiente con devolver `{ count : model.count + 1 }`.

Ya tenemos nuestro primer programa funcionando!
