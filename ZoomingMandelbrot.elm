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
            Mandelbrot.zoomViewport y x model
                |> Mandelbrot.computeAll


view : Model -> Html Msg
view model =
    div []
        [ Mandelbrot.view ZoomToward model
        ]
