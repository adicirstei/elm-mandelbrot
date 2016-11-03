module Mandelbrot exposing (Model, init, view)

import Dict exposing (Dict)
import Html exposing (..)


type alias Point =
    ( Int, Int )


type alias Model =
    { width : Int
    , height : Int
    , computed : Dict Point Int
    }


init : Int -> Model
init size =
    { width = size
    , height = size
    , computed = Dict.empty
    }


view : Model -> Html msg
view model =
    div []
        (List.map viewRow [0..model.height])
