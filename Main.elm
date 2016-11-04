module Main exposing (..)

import Mandelbrot
import IncrementalMandelbrot
import Html.App


-- main =
--     Mandelbrot.init 200
--         |> Mandelbrot.computeAll
--         |> Mandelbrot.view


main =
    Html.App.program
        { init = IncrementalMandelbrot.init 400
        , update = IncrementalMandelbrot.update
        , view = IncrementalMandelbrot.view
        , subscriptions = \_ -> Sub.none
        }
