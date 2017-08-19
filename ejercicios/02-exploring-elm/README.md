# 02 - De compras con Elm

El propósito de este ejercicio es empezar a entender cómo se hacen programas con el lenguaje Elm. Si hiciste el ejercicio anterior, ya sabés cómo mostrar html en la pantalla! Ahora vamos por algo (solo un poco) más complejo. La consigna es simple, partimos de un string que tiene esta forma:

```elm
listaDeCompras : String
listaDeCompras =
    """
    10 Cervezas: $275
    15 paquetes de papas fritas: $1000
    4 Coca Cola: $213
    2 Fernet: $300
    """
```

Queremos mostrar una tabla con la misma información que está en ese string.  La tabla tiene dos columnas: descripción y precio. En el footer de la tabla queremos mostrar el total de la compra. Empecemos!

## 1 - Analizando la definición de `html`

Si miramos el código de `app/src/Main.elm` vemos que ya tenemos una estructura básica del marcado que se muestra en el navegador. En el ejercicio anterior mencionamos que Elm tiene una función para cada elemento del DOM. Estas funciones reciben dos parámetros, el primero es una lista de atributos (`Html.Attributes`), y el segundo una lista de nodos hijos (`Html msg`). Cada una de estas funciones devuelve una estructura de datos de tipo `Html msg`. Precisamente, esa estructura de datos es un árbol, y está construido usando Records. Es importante destacar que el llamado a estas funciones, como cualquier funcion en Elm, no produce ningún tipo de side-effect (por ejemplo, estas funciones no renderizan esta estructura en el navegador) lo único que hacen es devolver esta representación del DOM que será usada por el runtime de Elm para generar el HTML.

```elm
main : Html msg
main =
    div [ class "container" ]
        [ h1 [] [ text "Ejercicio 2" ]
        , p [] [ text "De compras con Elm" ]
        , hr [] []
        , div [] []
        ]
````


## 2 -  Definir las estructuras de datos del programa.

Elm es un lenguaje funcional de tipado estático y fuertemente tipado. El type system de Elm es muy potente, pero no se parece en nada a los lenguajes tipados tradicionaes (Java, C#, C). Sino que viene de otra famila de lenguajes (ML, Haskell, F#). En Elm, por ejemplo, no tenemos Classes (ni las vamos a tener). Al ser un lenguaje funcional, el programa está compuesto por datos y funciones que operan sobre esos datos. Los datos que tu programa puede operar se representan con estructuras de datos abstractas. Lo primero que tenemos que hacer en un programa Elm, es definir con qué datos nuestro sistema opera, y cómo vamos a representar esos datos.

Vamos con los simples. La consigna habla de descipciones, de precios y de tablas. Para ese tipo de datos simples, contamos con las estructuras de datos nativas de Elm. Vamos a usar un `Float` para representar precios, `String` para representar descripciones y, como es una tabla, vamos a tener un lista de datos, y la misma podemos representarla usando el type `List`. 

Querés aprender mas sobre estos types? Estos types forman parte del módulo Core de Elm:

- http://package.elm-lang.org/packages/elm-lang/core/latest/

La documentación de los types mencionados está en estos links:

- http://package.elm-lang.org/packages/elm-lang/core/latest/Basics 
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/String
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/List

Además de los types estructurales, lo más importante es definir las entidades que forman parte del dominio específico de nuestra aplicación. En este caso tenemos una lista de compras, y cada ítem de la lista agrupa descripción y precio. Cuando queremos agrupar distintos valores en una misma estructura, en Elm tenemos una estructura de datos muy potente: los Records.

- http://elm-lang.org/docs/records

Un record es lo más parecido a un objeto en JS, con la diferencia pricipal de que es inmutable como todas las estructuras de datos en Elm, y algunas otras diferencias que iremos viendo sobre la marcha.

Nuestros items podrían representarse de este modo:

```elm
item =
    { description = "10 Cervezas"
    , price = 275.0
    }
```

Pegá ese código debajo de `listaDeCompras`. Lo que estamos haciendo es crear una variable `item`, que es un Record con dos propiedades `description` y `price`. Cuál es el type de esa variable? Si ponemos el cursor sobre el nombre de la variable, el compilador de Elm nos sugiere el type:

```elm
item : { description : String, price : Float }
```

Elm permite crear `alias` para estructuras de datos complejas. Los `type alias` son una forma de crear types personalizados, que además de comodidad a la hora de crear los type anotations, hacen que nuestro programa sea más legible. Definamos entonces un type alias llamado `Item` que va a ser la entidad principal de nuestro programa.


```elm
type alias Item =
    { description : String
    , price : Float
    }
```

Luego podemos crear variables de este type usando el type alias en las annotations


```elm
type alias Item =
    { description : String
    , price : Float
    }


item : Item
item =
    { description = "10 Cervezas"
    , price = 275.0
    }
```

## 3 -  Crear la vista de la aplicación, usando variables hardcodeadas para representar los ítems

Ahora que ya sabemos cómo son las estructuras de datos de nuestro programa podemos usar variables harcodeadas para representar los datos, dejando la parte del extracción de datos del string `listaDeCompras` para el final. Crear cuatro variables llamadas `item1`, `item2`, `item3` e `item4` todas ellas de tipo `Item` y una variable que contenga la lista de ítems llamada `itemList`. Usá el compilador de Elm como guía para crear los types annotations.

```elm
type alias Item =
    { description : String
    , price : Float
    }


item1 : Item
item1 =
    { description = "10 Cervezas"
    , price = 275.0
    }


item2 : Item
item2 =
    { description = "15 paquetes de papas fritas"
    , price = 1000.0
    }


item3 : Item
item3 =
    { description = "4 Coca Cola"
    , price = 213.0
    }


item4 : Item
item4 =
    { description = "2 Fernet"
    , price = 300.0
    }


listItem : List Item
listItem =
    [ item1, item2, item3, item4 ]
```

Finalmente creamos una función `itemTable` que recibe una lista de `Item`s y devuelve algo de tipo `Html`

```elm
itemTable : List Item -> Html msg
itemTable list =
    table []
        [ thead []
            [ tr []
                [ th [] [ text "Descripción" ]
                , th [] [ text "Precio" ]
                ]
            ]
        , tbody [] <|
            List.map
                (\item ->
                    tr []
                        [ td [] [ text item.description ]
                        , td [] [ text <| toString item.price ]
                        ]
                )
                list
        ]

```

## 4 - Crear una función `calculateTotal` que reciba una lista de ítems y devuelva un `Float` con el total de la compra.

Elm tiene varias funciones para trabajar con listas. En este caso necesitamos una función que transforme una lista en un valor particular. Si estuvieramos en JS probablemente usaríamos el método `reduce` de los arrays para realizarlo. El equivalente en Elm es `List.foldr`.

http://package.elm-lang.org/packages/elm-lang/core/latest/List#foldr

```elm
calculateTotal : List Item -> Float
calculateTotal list =
    List.foldr (\item b -> item.price + b) 0 list


itemTable : List Item -> Html msg
itemTable list =
    table []
        [ thead []
            [ tr []
                [ th [] [ text "Descripción" ]
                , th [] [ text "Precio" ]
                ]
            ]
        , tbody [] <|
            List.map
                (\item ->
                    tr []
                        [ td [] [ text item.description ]
                        , td [] [ text <| toString item.price ]
                        ]
                )
                list
        , tfoot []
            [ text <| "Total: " ++ (toString <| calculateTotal list) ]
        ]
```

## 5 - Remover las variables hardcodeadas y crear una función `extractItems` que reciba un String (`listaDeCompras`) y devuelva una lista de ítems

Tenemos que crear una función con este type: `extractItems: String -> List Item`. Para ello vamos a utilizar varias de las funciones de los módulos `String`, `List`, y types `Result` y `Maybe` que nos van a ayudar a lidear con operaciones que potencialmente pueden fallar y con datos que pueden estar presentes o no (en Elm no tenemos valores `null` ni bloques `try`/`catch`).

- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/String
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/List
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Maybe
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Result
