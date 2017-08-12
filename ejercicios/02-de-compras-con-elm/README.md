# 02 - De compras con Elm

El proposito de este ejercicio es empezar a entender como se hacen programas con el lenguaje Elm. Si hiciste el ejercicio anterior, ya sabes como mostrar Html en la pantalla! Ahora vamos por algo (solo un poco) mas complejo. La consigna es simple, partimos de un string que tiene esta forma:

```
listaDeCompras : String
listaDeCompras =
    """
    10 Cervezas: $275
    15 paquetes de papas fritas: $1000
    4 Coca Cola: $213
    2 Fernet: $300
    """
```

Queremos mostrar una tabla con la misma informacion que esta en ese string.  La tabla tiene dos columnas descripcion y precio. En el footer de la tabla queremos mostrar el total de la compra. Empecemos!

## 1 - Analizando la definicion de `html`

Si miramos el codigo de `app/src/Main.elm` vemos que ya tenemos una estructura basica del marcado que se muestra en el navegador. En el ejercicio anterior mencionamos que Elm tiene una funcion para cada elemento del DOM. Estas funciones reciben dos parametros, el primero es una lista de atributos (`Html.Attributes`), y el segundo una lista de nodos hijos (`Html msg`). Cada una de estas funciones devuelve una estructura de datos de tipo `Html msg`. Presisamente, esa estructura de datos es un arbol, y esta construido usando Records. Es importante destacar que el llamado a estas funciones como cualquier funcion en Elm, no produce ningun tipo de side effect (por ejemplo, estas funciones no renderizan esta estructura en el navegador) lo unico que hacen es devolver esta representacion del DOM que sera usada por el runtime del Elm para generar el HTML.

```
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

Elm es un lenguaje funcional de tipado estatico y fuertemente tipado. El type system de Elm es muy potente, pero no se parece en nada a los lenguajes tipados tradicionaes (Java, C#, C). Sino que viene de otra famila de lenguajes (ML, Haskell, F#). En Elm por ejemplo, no tenemos Classes (ni las vamos a tener). Al ser un lenguaje funcional, el programa esta compuesto por datos y funciones que operan sobre esos datos. Los datos que tu programa puede operar se representan con estructuras de datos abstractas. Lo primero que tenemos que hacer en un programa Elm, es definir con que datos nuestro sistema opera, y como vamos a representar esos datos.

Vamos con los simples. La consigna habla de descipciones, de precios y de tablas. Para ese tipo de datos simples, contamos con las estructuras de datos nativas de Elm. Vamos a usar un `Float` para representar precios, `String` para representar descripciones, y como es una tabla, vamos a tener un lista de datos, y la misma podemos representarla usando el type `List`. 

Queres aprender mas sobre estos types? Estos types forman parte del modulo Core de Elm:

- http://package.elm-lang.org/packages/elm-lang/core/latest/

La documentacion de los types mencionados esta en estos links:

- http://package.elm-lang.org/packages/elm-lang/core/latest/Basics 
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/String
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/List

Ademas de los types estructurales, lo mas importante es definir las entidades que forman parte del dominio especifico de nuestra aplicacion. En este caso tenemos una lista de compras, y cada item de la lista agrupa descripcion y precio. Cuando queremos agrupar distintos valores en una misma estructura, en Elm tenemos una estructura de datos muy potente: los Records.

- http://elm-lang.org/docs/records

Un record es lo mas parecido a un objeto en JS, con la diferencia pricipal de que es inmutable como todas las estructuras de datos en Elm, y algunas otras diferencias que iremos viendo sobre la marcha.

Nuestros items podrian reprecentarse de este modo:

```
item =
    { description = "10 Cervezas"
    , price = 275.0
    }
```

Pega ese codigo debajo de `listaDeCompras`. Lo que estamos haciendo es crear una variable item, que es un Record con dos propiedades "description" y "price". Cual es el type de esa variable? Si ponemos el cursor sobre el nombre de la variable, el compilador de Elm nos sugiere el type:

```
item : { description : String, price : Float }
```

Elm permite crear `alias` para estructuras de datos complejas. Los `type alias` son una forma de crear types personalizados, que ademas de comodidad a la hora de crear los type anotations, hacen que nuestro programa sea mas legible. Definamos entonces un type alias llamado `Item` que va a ser la entidad principal de nuestro programa.


```
type alias Item =
    { description : String
    , price : Float
    }
```

Luego podemos crear variables de este type usando el type alias en las definirions


```
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

## 3 -  Crear la vista de la aplicacion, usando variables hardcodeadas para representar los items

Ahora que ya sabemos como son las estructuras de datos de nuestro programa podemos usar variables harcodeadas para representar los datos, dejando la parte del extraccion de datos del string `listaDeCompras` para el final. Crear cuatro variables llamadas `item1`, `item2`, `item3` e `item4` todas ellas de tipo `Item` y una variable que contenga la lista de items llamada `itemList`. Usa el compilador de Elm como guia para crear los types anotations.

```
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

Finalmente creamos una funcion `itemTable` que recibe una lista de Items y devuelve algo de tipo Html

```
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

## 4 - Crear una funcion `calculateTotal` que reciba una lista de items y devuelva un Float con el total de la compra.

Elm tiene varias funciones para trabajar con listas. En este caso necesitamos una funcion que transforme una lista en un valor particular. Si estuvieramos en JS probablemente usariamos el metodo reduce de los arrays para realizarlo. El equivalente en Elm es `List.foldr`.

http://package.elm-lang.org/packages/elm-lang/core/latest/List#foldr

```
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

## 5 - Remover las variables hardcodeadas y crear una funcion `extractItems` que reciba un String (listaDeCompras) y devuelva una lista de items

Tenemos que crear una funcion con este type: `extractItems: String -> List Item`. Para ello vamos a utilizar varias de las funciones de los modulos String, List, y types Result y Maybe que nos van a ayudar a lidear con operaciones que potencialmente pueden fallar y con datos que pueden estar presentes o no (en elm no tenesmos valores Null ni bloques try/catch).

- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/String
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/List
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Maybe
- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Result

