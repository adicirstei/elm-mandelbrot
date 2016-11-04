module Main exposing (..)

import Mandelbrot


--import IncrementalMandelbrot

import ZoomingMandelbrot
import Html.App


-- main =
--     Mandelbrot.init 200
--         |> Mandelbrot.computeAll
--         |> Mandelbrot.view
--
-- main =
--     Html.App.program
--         { init = IncrementalMandelbrot.init 200
--         , update = IncrementalMandelbrot.update
--         , view = IncrementalMandelbrot.view
--         , subscriptions = \_ -> Sub.none
--         }


main =
    Html.App.beginnerProgram
        { model = ZoomingMandelbrot.init 200
        , update = ZoomingMandelbrot.update
        , view = ZoomingMandelbrot.view
        }
