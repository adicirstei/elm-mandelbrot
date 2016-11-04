module IncrementalMandelbrot
    exposing
        ( Model
        , Msg
        , view
        , update
        , init
        )

import Mandelbrot
import Task
import Html exposing (Html)
import Process


type alias Model =
    { fractal : Mandelbrot.Model
    , nextRow : Int
    }


type Msg
    = CalculateNextRow


calcNextRowCmd : Cmd Msg
calcNextRowCmd =
    Process.sleep 0
        |> Task.perform
            (always CalculateNextRow)
            (always CalculateNextRow)


init : Int -> ( Model, Cmd Msg )
init size =
    ( { fractal = Mandelbrot.init size, nextRow = 0 }
    , calcNextRowCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    if model.nextRow <= model.fractal.height then
        case msg of
            CalculateNextRow ->
                ( { model
                    | fractal = Mandelbrot.computeRow model.nextRow model.fractal
                    , nextRow = model.nextRow + 1
                  }
                , calcNextRowCmd
                )
    else
        ( model, Cmd.none )


view : Model -> Html msg
view model =
    Mandelbrot.view model.fractal
