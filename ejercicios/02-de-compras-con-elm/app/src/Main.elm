module Main exposing (..)

import Html exposing (Html, div, h1, hr, p, table, tbody, td, text, tfoot, th, thead, tr)
import Html.Attributes exposing (attribute, class)


listaDeCompras : String
listaDeCompras =
    """
    10 Cervezas: $275
    15 paquetes de papas fritas: $1000
    4 Coca Cola: $213
    2 Fernet: $300
    """


main : Html msg
main =
    div [ class "container" ]
        [ h1 [] [ text "Ejercicio 2" ]
        , p [] [ text "De compras con Elm" ]
        , hr [] []
        , div [] []
        ]
