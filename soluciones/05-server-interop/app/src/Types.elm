module Types exposing (..)

import RemoteData exposing (..)


type alias Planet =
    { name : String
    , rotationPeriod : String
    , orbitalPeriod : String
    , diameter : String
    , climate : String
    , gravity : String
    , terrain : String
    , surfaceWater : String
    , population : String
    }


type alias Model =
    { planets : WebData (List Planet)
    }


type Msg
    = LoadPlanets
    | PlanetsResponse (WebData (List Planet))
