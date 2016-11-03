module Main exposing (..)

import Mandelbrot


main =
    Mandelbrot.init 100
        |> Mandelbrot.computeCell ( 5, 5 )
        |> Mandelbrot.view
