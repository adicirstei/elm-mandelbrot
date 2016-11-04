module Main exposing (..)

import Mandelbrot


main =
    Mandelbrot.init 350
        |> Mandelbrot.computeAll
        |> Mandelbrot.view
