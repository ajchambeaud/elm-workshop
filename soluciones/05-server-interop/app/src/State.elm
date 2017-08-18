module State exposing (..)

import RemoteData exposing (..)
import Rest exposing (fetchPlanetsCmd)
import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    ( { planets = NotAsked }, fetchPlanetsCmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadPlanets ->
            ( { model | planets = Loading }, fetchPlanetsCmd )

        PlanetsResponse data ->
            ( { model | planets = data }, Cmd.none )
