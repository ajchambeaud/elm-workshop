module Main exposing (..)

import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src)
import Time exposing (Time, second)


---- MODEL ----


type alias Model =
    { time : String }


init : ( Model, Cmd Msg )
init =
    ( { time = "" }, Cmd.none )



---- UPDATE ----


type Msg
    = FormatedTimeReceived String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormatedTimeReceived time ->
            ( { model | time = time }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.time ]
        ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
