module Main exposing (..)

import Html exposing (Html, button, div, h2, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


---- MODEL ----


type alias Model =
    {}


model : Model
model =
    {}



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    model



---- VIEW ----


view : Model -> Html Msg
view model =
    div
        []
        [ text "Lets make a counter!" ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = model
        , update = update
        }
