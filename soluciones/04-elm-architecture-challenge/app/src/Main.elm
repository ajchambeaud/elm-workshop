module Main exposing (..)

import Html exposing (Html, button, div, h2, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


---- MODEL ----


type alias Counter =
    { id : Int
    , count : Int
    }


type alias Model =
    { counters : List Counter
    , seed : Int
    }


model : Model
model =
    { counters = [ Counter 1 0 ]
    , seed = 1
    }



---- UPDATE ----


type Msg
    = Increase Int
    | Decrease Int
    | RemoveCounter Int
    | AddCounter


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase id ->
            { model | counters = increaseCounter id model.counters }

        Decrease id ->
            { model | counters = decreaseCounter id model.counters }

        RemoveCounter id ->
            { model | counters = removeCounter id model.counters }

        AddCounter ->
            { model
                | counters = addCounter model.seed model.counters
                , seed = model.seed + 1
            }


increaseCounter : Int -> List Counter -> List Counter
increaseCounter id list =
    List.map
        (\counter ->
            if counter.id /= id then
                counter
            else
                { counter | count = counter.count + 1 }
        )
        list


decreaseCounter : Int -> List Counter -> List Counter
decreaseCounter id list =
    List.map
        (\counter ->
            if counter.id /= id then
                counter
            else
                { counter | count = counter.count - 1 }
        )
        list


removeCounter : Int -> List Counter -> List Counter
removeCounter id list =
    List.filter
        (\counter -> counter.id /= id)
        list


addCounter : Int -> List Counter -> List Counter
addCounter seed list =
    list ++ [ Counter (seed + 1) 0 ]



---- VIEW ----


counterView : Counter -> Html Msg
counterView counter =
    div [ class "counter-wrapper" ]
        [ div
            [ class "counter" ]
            [ button [ onClick <| Increase counter.id ] [ text "+" ]
            , div [] [ text <| toString counter.count ]
            , button [ onClick <| Decrease counter.id ] [ text "-" ]
            ]
        , button [ onClick <| RemoveCounter counter.id ] [ text "remove this counter" ]
        ]


view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ h2 [] [ text "04 - More Counters" ]
        , button [ onClick AddCounter ] [ text "AddCounter" ]
        , div [ class "counters" ] <|
            List.map
                (\counter -> counterView counter)
                model.counters
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = model
        , update = update
        }
