module View exposing (..)

import Html exposing (Html, button, div, h1, li, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (..)


planetsList : List Planet -> Html Msg
planetsList list =
    ul [] <| List.map (\planet -> li [] [ text planet.name ]) list


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Star Wars Planets" ]
        , button [ onClick LoadPlanets ] [ text "Reload" ]
        , planetsList model.planets
        ]
