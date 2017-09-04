# 06 - JS Interop

Muchas veces necesitamos que nuestra app Elm se comunique con codigo JS por diversos motivos. Desde comunicacion con otra parte de la app o simplemente porque queremos reusar alguna libreria que esta escrita en JS. La forma de interactuar con JS desde Elm, de forma de mantener la seguridad del lado de Elm, es hablar con JS como si hablaramos con un servidor. Para eso usamos los puertos de Elm.

## Elm Ports

En este ejercicio vamos a usar la libreria Moment.js para obtener un time con un formato determinado. Tambien vamos a incorporar un elemento mas a nuestra arquitectura de Elm que son las Subscriptions. Mediente las subscriptions, podemos recibir mensajes periodicamente desde el Runtime de Elm y modificar el estado de la aplicacion en consecuencia. En este caso, queremos que el runtime nos notifique cada vez que pase un segundo, y en todos los casos invocar a una funcion de JS para obtener un time formateado por Moment.js.

### 1 - Activar los ports para el modulo Main.elm

Modificamos la declaracion del modulo Main para pedirle al runtime que habilite los puertos para ese modulo.

```elm
port module Main exposing (..)
```

### 2 - Definimos dos puertos en elm para enviar y recibir mensajes desde JS

```elm
---- PORTS ----


port requestMomentTime : String -> Cmd msg


port responseMomentTime : (String -> msg) -> Sub msg
```

### 3 - Agregar codigo JS para interactuar con la applicacion Elm

Modificamos la funcion getTime para que en lugar de retornar el valor, se lo envie a Elm usando el puerto `responseMomentTime`. Llamamos a la funcion getTime desde JS cada vez que recibimos un llamado de elm a `requestMomentTime`.

```js
const app = Main.embed(document.getElementById('root'));

const getTime = () => {
  const strTime = moment().format('MMMM Do YYYY, h:mm:ss a');
  app.ports.responseMomentTime.send(strTime);
}

app.ports.requestMomentTime.subscribe(getTime);
```

### 4 - Agregar una subscripcion para recibir notificaciones del runtime de Elm una vez por segundo. Agregar otra para mapear los mensajes del puerto  `responseMomentTime` al mensaje `FormatedTimeReceived`.

```elm
---- UPDATE ----


type Msg
    = FormatedTimeReceived String
    | Tick Time


---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ responseMomentTime FormatedTimeReceived
        , Time.every second Tick
        ]
```

### 5 - Modificar la funcion update, para mandar el `requestMomentTime` a JS cada vez que pasa un segundo

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( model, requestMomentTime "" )

        FormatedTimeReceived time ->
            ( { model | time = time }, Cmd.none )
```