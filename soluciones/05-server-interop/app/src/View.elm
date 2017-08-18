module View exposing (..)

import Html exposing (Html, button, div, h1, li, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import RemoteData exposing (..)
import Types exposing (..)


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


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Star Wars Planets" ]
        , button [ onClick LoadPlanets ] [ text "Reload" ]
        , planetsList model.planets
        ]
