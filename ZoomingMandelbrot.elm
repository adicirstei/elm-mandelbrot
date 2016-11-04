module ZoomingMandelbrot
    exposing
        ( Model
        , init
        , update
        , Msg
        , view
        )

import Mandelbrot
import Html exposing (..)
import Html.Events exposing (..)
import Dict


type alias Model =
    Mandelbrot.Model


type Msg
    = ZoomToward ( Int, Int )


init : Int -> Model
init size =
    Mandelbrot.init size
        |> Mandelbrot.computeAll


update : Msg -> Model -> Model
update msg model =
    case Debug.log "msg" msg of
        ZoomToward ( x, y ) ->
            { model
                | min = Mandelbrot.complexFromGridModel (x - 10) (y - 10) model
                , max = Mandelbrot.complexFromGridModel (x + 10) (y + 10) model
                , computed = Dict.empty
            }
                |> Mandelbrot.computeAll


view : Model -> Html Msg
view model =
    div []
        [ Mandelbrot.view ZoomToward model
        ]
