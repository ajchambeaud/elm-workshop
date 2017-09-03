# 05 - Server interop

En los ejercicios anteriores vimos ejemplos de la Elm Architecture usando la funcion `beginnerProgram` del modulo `Html`. Esta es una version simplificada de un programa Elm, ya que le falta una componente importante: La comunicacion con el servidor. Un programa compuesto unicamente por funciones puras como propone Elm, no puede tener side effects. Un side effect (efecto secundario) es un termino que se le da en el paradigma funcional a cualquier modificacion por parte del codigo de una funcion de un scope que no le pertenece. Es decir, una funcion puede trabajar solo con los parametros que recibe y a partir de ellos generar y retornar un nuevo valor. 

```Una funcion no puede modificar variables globales, hacer una peticion AJAX o leer un archivo bajo el paradigma funcional puro.```


## Comands

Sin side effects sin embargo, la utilidad de un programa seria bastante limitada. En algun momento vamos a querer interactuar con el mundo exterior. La forma de resolver este problema dentro de la arquitectura Elm manteniendo el codigo que escribimos puro, es delegar los side effects en el runtime de Elm mediante unas estructuras de datos especiales llamadas comandos.

```Un comando es una estructura de dato especial que le da instrucciones al runtime de Elm para llevar a cabo un side effect. El comando ademas especifica un mensaje que espera recibir del runtime una vez efectuado el side effect.```


## Program Advance

Veamos las diferencias en el codigo base de este ejercicio. Para empezar, dividimos el codigo en Modulos. Cada modulo puede definir y exponer funciones para ser usadas por otras partes de la aplicación. Veamos el codigo del archivo `Main.elm`

```elm
main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
```


En lugar de usar la funcion `beginnerProgram` para construir el programa, usamos `Html.program`, que recibe `init` en lugar de `model`, y `subscriptions`. Dejamos de lado las subscriptions por ahora (que son otra forma de comunicarnos con el runtime de Elm). Veamos el codigo de la funcion `update` y de `init` en el archivo `State.elm`.

```elm
init : ( Model, Cmd Msg )
init =
    ( { planets = [] }, Cmd.none )
```

`init` es una tupla que tiene dos valores. Elm primero es el modelo de la aplicacion, y el segundo valor es un comando. El modelo esta inicializado como un record con un solo field `planets` que es un array vacio. El comando esta inicializado con `Cmd.none` que es un comando especial que le dice al runtime basicamente "no hagas nada".

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model
``` 

La funcion update ahora devuelve una tupla, pasandole al runtime no solo el nuevo modelo, sino tambien un comando. Si prestamos atencion al tipo de dato del comando, vemos que es de tipo `Cmd Msg`. Esto significa que es un comando, que puede generar en el runtime de Elm, mensajes de tipo `Msg`.

## Http en Elm

A continuacion vamos a empezar a modificar nuestro programa para agregarle una capa de comunicacion con el servidor. El objetivo es mostrar una lista de planetas de la saga Star Wars tomada de la API publica `https://swapi.co`. Para poder trabajar con datos remotos en Elm tenemos que resolver 3 problemas.

1 - Modelo

Para manejar datos que vienen de un servidor, necesitamos modificar nuestro modelo para contemplar los diferentes estados en los que la aplicacion podria encontrarse respecto a la carga de los mismos. Existe una libreria que nos ayuda con este trabajo llamada [RemoteData](http://package.elm-lang.org/packages/krisajenkins/remotedata/4.3.0/RemoteData).

2 - Http comand

Necesitamos crear un comando para describirle al runtime de Elm el tipo de peticion que queremos hacer. Para ello Elm cuenta con el [modulo Http](http://package.elm-lang.org/packages/elm-lang/http/1.0.0/Http) que expone varias funciones y estructuras de datos para trabajar con el protocolo Http.


3 - JSON Decoders

Una vez que el runtime de Elm obtiene una respuesta del servidor, usa la informacion que le facilitamos en el Comand para envolver esa data en un mensaje de tipo `Msg` e invocar a nuestra funcion `update` con el. Como la respuesta del servidor suele ser un json string, el runtime necesita que le pasemos una funcion para transformar ese string en una estructura de datos definida por nuestro programa. Esas funciones se conocen como Decoders. En JS tenemos un solo decoder que es `JSON.parse` que lo que hace es intentar transformar el string en un objeto de JS. La conversion de JSON -> JS es automatica, pero en Elm no podemos trabajar de ese modo. Principalmente porque el compilador de Elm necesita saber a priori todas las estructuras de datos con la que nuestro sistema trabaja, no se pueden crear nuevos types en runtime ya que si lo hacemos perderiamos todos los chequeos del compilador y nos arriesgamos a tener excepciones en runtime que es lo que Elm trata de evitar. Los json decoders son uno de los capitulos mas complejos de Elm y lleva un tiempo procesar como funcionan viniendo de JS. Vamos a ver un caso simple usando un modulo llamado [elm-decode-pipeline](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest) que vuelve la tarea un poco mas sencilla.


## Resolviendo el Ejercicio

### 1 - Actualizar el modelo para usar RemoteData

En `Types.elm` importar el module `RemoteData`

```elm
import RemoteData exposing (..)
```

Modificar el modelo wrappeando nuestras estructura de datos `List Planet` con el type `WebData`.

```elm
type alias Model =
    { planets : WebData (List Planet)
    }


type Msg
    = LoadPlanets
    | PlanetsResponse (WebData (List Planet))
```

WebData define 4 estados posibles para nuestros datos. `NotAsked` si el request aun no fue enviado, `Loading` si el servidor aun no contesto, `Failure e` si el resultado fue un error, o `Success a` si el resultado fue exitoso. Si el resultado fue un error, al valor `Failure` lo acompaña un error de tipo `Http.Error`. Si el resultado es exitoso, al tipo `Success` lo acompaña la estructura de datos resultante de parsear el JSON, en nuestro caso `List Planet`.


```elm
type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a

type alias WebData a = 
    RemoteData Error a
```

### 2 - Actualizar la vista para tener en cuenta los estados posibles del nuevo modelo

La unica forma de extraer un dato de adentro de un type que lo envuelve es usando pattern matching. El compilador de Elm nos va a obligar a tener en cuenta todos los casos posibles cuando queramos usar algo de tipo WebData en una interfaz, evitando un conocido anti pattern de la UI, que es mostrar un mensaje de "lista vacia" cuando en realidad los datos aun no se terminaron de cargar.

Modificar el archivo `View.elm` de este modo:

```elm
planetsList : WebData (List Planet) -> Html Msg
planetsList list =
    case list of
        NotAsked ->
            text ""

        Loading ->
            text "loading planets..."

        Failure err ->
            text <| toString err

        Success planets ->
            ul [] <| List.map (\planet -> li [] [ text planet.name ]) planets
```

### 3 - Actualizar la funcion update y el modelo inicial para enviar los comandos 

En el archivo `State.elm`, definimos el estado inicial del programa. Al iniciar la aplicacion, se debe enviar el comando `fetchPlanetsCmd` al runtime de Elm. Esto mismo debe hacerse cada vez que se recibe el mensaje `LoadPlanets`. Ademas, debemos modificar el valor de la lista en cada caso, de acuerdo a los valores posibles de WebData.

```elm
init : ( Model, Cmd Msg )
init =
    ( { planets = NotAsked }, fetchPlanetsCmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadPlanets ->
            ( { model | planets = Loading }, fetchPlanetsCmd )

        PlanetsResponse data ->
            ( { model | planets = data }, Cmd.none )
```

### 4 - Crear un json decoder para el data type `List Planet`

Necesitamos crear un `Decoder` para una estructura de datos especifica de nuestra applicacion. El modulo `Json.Decode` expone varias funciones para crear decoders para los tipos de datos primitivos de Elm (list, string, int, etc) y varias utilidades como `at` para seleccionar un path adentro de una estructura JSON. Podemos usar esos helpers para construir nuestro decoder junto con algunas utilidades adicionales para trabajar con estructuras de datos mas complejas como los records.

Si nos fijamos en el archivo `Types.elm` nuestra estructura de datos para representar un `Planet` es la siguiente:

```elm
type alias Planet =
    { name : String
    , rotationPeriod : String
    , orbitalPeriod : String
    , diameter : String
    , climate : String
    , gravity : String
    , terrain : String
    , surfaceWater : String
    , population : String
    }

```

Veamos que forma tiene el json que nos devuelve `https://swapi.co/api/planets`.

```json
{
    "count": 61,
    "next": "https://swapi.co/api/planets/?page=2",
    "previous": null,
    "results": [
        {
            "name": "Alderaan",
            "rotation_period": "24",
            "orbital_period": "364",
            "diameter": "12500",
            "climate": "temperate",
            "gravity": "1 standard",
            "terrain": "grasslands, mountains",
            "surface_water": "40",
            "population": "2000000000",
            "residents": [
                "https://swapi.co/api/people/5/",
                "https://swapi.co/api/people/68/",
                "https://swapi.co/api/people/81/"
            ],
            "films": [
                "https://swapi.co/api/films/6/",
                "https://swapi.co/api/films/1/"
            ],
            "created": "2014-12-10T11:35:48.479000Z",
            "edited": "2014-12-20T20:58:18.420000Z",
            "url": "https://swapi.co/api/planets/2/"
        },
        {
          ...
        }
    ]
```

La lista se encuentra adentro del field `results`. Creamos el decoder para la lista dentro del archivo `Rest.elm` esta forma:

```elm
listDecoder : Decoder (List Planet)
listDecoder =
    at [ "results" ] (list planetDecoder)

```

Lo que estamos diciendo es que dentro de el path `["results"]` se encuentra una lista, y que para cada uno de los elementos de la lista use la funcion `planetDecoder` que tenemos que crear.

```elm
planetDecoder : Decoder Planet
planetDecoder =
    decode Planet
        |> required "name" string
        |> required "rotation_period" string
        |> required "orbital_period" string
        |> required "diameter" string
        |> required "climate" string
        |> required "gravity" string
        |> required "terrain" string
        |> required "surface_water" string
        |> required "population" string
```

Para crearla usamos la funcion `decode` del modulo `elm-decode-pipeline`, que nos permite crear un decoder para cada uno de los fields de nuestro record Planet (en orden) especificando el `field` dentro del json y la funcion decoder que queremos usar para cada field. Como son todos strings en este caso, usamos la funcion `string` en todos ellos.

Finalmente, tenemos todo lo necesario para crear el comando. En este momento nuestro comando es un alias para `Cmd.none` es decir que le esta diciendo al runtime que no realice ningun side effect. Vamos a usar el modulo Http para crear el comando de la siguente forma:

```elm
fetchPlanetsCmd : Cmd Msg
fetchPlanetsCmd =
    listDecoder
        |> Http.get "https://swapi.co/api/planets"
        |> RemoteData.sendRequest
        |> Cmd.map PlanetsResponse

```

Analicemos este utilmo codigo por partes:

```elm
Http.get "https://swapi.co/api/planets" listDecoder
```

Usando el pipe operator, partimos de nuestro decoder y se lo pasamos a la funcion `Http.get` que simplemente necesita saber a donde hay que hacer la peticion (url) y que decoder usar cuando tenga los datos listos (listDecoder). Luego el resultado de esa operacion es una estructura de tipo `Request`. Ese request se lo pasamos a `RemoteData.sendRequest` 

```elm 
        |> RemoteData.sendRequest
```

Que va a devolvernos algo de tipo `Cmd (WebData a)`.

```elm
        |> Cmd.map PlanetsResponse
```

Finalmente, usando Cmd.map mapeamos ese resultado a `(WebData (List Planet))` usando el mensage `PlanetsResponse`.
