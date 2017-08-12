# Instalacion del Entorno


## Node.js

### Instalar la version LTS de Node.js

Asegurate de tener node.js instalado, ya que varias tools dependen de node. Recomendamos instalar la version `6.11 (LTS)` que podes descargar de la pagina de node.

https://nodejs.org/es/

### Verificar la instalación

Al finalizar la instalacion, abri la consola de tu sistema operativo y ejecuta los sigueintes comandos para asegurarte de que todo se encuentra funcionando correctamente.

- `node -v` (deberias ver la salida `v6.11.2`)
- `npm -v` (deberias ver la salida `3.10.10`)


## Elm Plaform

### Intalar Elm Platform version 0.18

En este link vas a encontrar una guia para instalar Elm en tu plataforma. 

- https://guide.elm-lang.org/install.html

### Verificar la instalación

Al finalizar la instalacion, abri la consola de tu sistema operativo y ejecuta los sigueintes comandos para asegurarte de que todo se encuentra funcionando correctamente.

- `elm-repl -v` (deberias ver la salida `> 0.18.0`)
- `elm-reactor -v` (deberias ver la salida `> 0.18.0`)
- `elm-make -v` (deberias ver la salida `> elm-make 0.18 (Elm Platform 0.18.0)`)
- `elm-package` (deberias ver la ayuda del instalador de paquetes de Elm)


## Editor

### Intalar el editor de codigo VS Code

Podes usar otro editor, pero asegurate que tenga un buen soporte para Elm, y especielmante para `elm-format`. 

- https://code.visualstudio.com/ 

### Verificar la instalación

Al finalizar la instalacion, abri la consola de tu sistema operativo y ejecuta el siguiente comando:

- `code test.elm`

Ese comando deberia abrir el editor con el archivo `test.elm` para editar.


## elm-format

Una de las herramientas mas populares del ecosistema de Elm es `elm-format`, que permite darle un formato unificado al codigo Elm, de modo que el codigo Elm siempre se ve igual independientemente de quien lo escriba. De este modo la comunidad se las largas discuciones acerca de "coding rules" que no llevan a ningun lado.

https://github.com/avh4/elm-format

### Intalar elm-format

Para instalar esta tool podemos hacerlo con npm (ver instalacion de node)

- `npm install -g elm-format@exp`

### Verificar la instalación

Abri un nuevo archivo `test.elm` con tu editor con el siguiente contenido:

```
module Main exposing (..)


type alias User ={ name : String
, bio : String, pic : String}
```

Guarda el archivo, cerra el editor y desde la consola ejecuta el siguiente comando:

- `elm-format test.elm`

Cuando te pida confirmacion, confirma ('y' o 'si' dependiendo de la configuracion del sistema y luego Enter). Volve a abrir el archivo, y el mismo deberia parecerse un poco mas a esto:

```
module Main exposing (..)


type alias User =
    { name : String
    , bio : String
    , pic : String
    }
```

## Configira tu editor para Elm

En VS Code, en el menu lateral hay una opcion "Extensions". En el buscador tipea 'elm' y van a aparecer algunas extenciones para el lenguaje. Recomendamos instalar las siguientes:

- elm (Elm)
- elm-format (abadi199)

Por ultimo, edita las preferencias del Editor para habilitar el "format on save". Para esto abri las preferencias (Code -> Preferences -> Settings) y agregale esta linea al JSON de user settings:

- `"elm-format.formatOnSave": true,`

Reinicia el Editor y repeti la prueba que hicimos en `elm-format` pero simplemente pegando el primer codigo en el Editor y luego guardando. El codigo deberia formatearse automaticamente a la segunda version. 

Ya tenes todo listo para empezar!


## Extra: Fira Code

No es necesario para escribir codigo Elm, pero te recomendamos que le pegues una mirada a estas fonts:

- https://github.com/tonsky/FiraCode





