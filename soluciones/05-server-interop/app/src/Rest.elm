module Rest exposing (..)

import Http exposing (..)
import Json.Decode exposing (Decoder, at, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (..)
import Types exposing (..)


planetDecoder : Decoder Planet
planetDecoder =
    decode Planet
        |> required "name" string
        |> required "rotation_period" string
        |> required "orbital_period" string
        |> required "diameter" string
        |> required "climate" string
        |> required "gravity" string
        |> required "terrain" string
        |> required "surface_water" string
        |> required "population" string


listDecoder : Decoder (List Planet)
listDecoder =
    at [ "results" ] (list planetDecoder)


fetchPlanetsCmd : Cmd Msg
fetchPlanetsCmd =
    listDecoder
        |> Http.get "https://swapi.co/api/planets"
        |> RemoteData.sendRequest
        |> Cmd.map PlanetsResponse
