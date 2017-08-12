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


type alias Item =
    { description : String
    , price : Float
    }


createItem : List String -> Maybe Item
createItem list =
    case list of
        desc :: [ price ] ->
            case String.toFloat price of
                Ok p ->
                    Just <| Item desc p

                _ ->
                    Nothing

        _ ->
            Nothing



{-
   extractItems : String -> List Item
   extractItems data =
       let
           lines =
               String.lines listaDeCompras

           trimedLines =
               List.map (\line -> String.trim line) lines

           nonEmty =
               List.filter (\line -> line /= "") trimedLines

           itemList =
               List.map (\line -> String.split ": $" line) nonEmty

           result =
               List.filterMap (\data -> createItem data) itemList
       in
       result
-}


extractItems : String -> List Item
extractItems data =
    data
        |> String.lines
        |> List.map (\line -> String.trim line)
        |> List.filter (\line -> line /= "")
        |> List.map (\line -> String.split ": $" line)
        |> List.filterMap (\data -> createItem data)


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


main : Html msg
main =
    div [ class "container" ]
        [ h1 [] [ text "Ejercicio 2" ]
        , p [] [ text "De compras con Elm" ]
        , hr [] []
        , div [] [ itemTable <| extractItems listaDeCompras ]
        ]
