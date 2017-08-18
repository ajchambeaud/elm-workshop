module Main exposing (..)

import Html exposing (Html, button, div, h2, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


---- MODEL ----


type alias Model =
    { count : Int }


model : Model
model =
    { count = 0 }



---- UPDATE ----


type Msg
    = Increase
    | Decrease


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase ->
            { model | count = model.count + 1 }

        Decrease ->
            { model | count = model.count - 1 }



---- VIEW ----


view : Model -> Html Msg
view model =
    div
        [ class "counter" ]
        [ button [ onClick Increase ] [ text "+" ]
        , div [] [ text <| toString model.count ]
        , button [ onClick Decrease ] [ text "-" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = model
        , update = update
        }
