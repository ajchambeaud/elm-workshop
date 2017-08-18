module Main exposing (..)

import Html exposing (..)
import State exposing (..)
import Types exposing (..)
import View exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
