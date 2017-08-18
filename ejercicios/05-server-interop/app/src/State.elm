module State exposing (..)

import RemoteData exposing (..)
import Rest exposing (fetchPlanetsCmd)
import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    ( { planets = [] }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model
