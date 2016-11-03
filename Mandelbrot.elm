module Mandelbrot exposing (Model, init, view)

type alias Model = {
  width : Int
  height : Int
  computed : Dict Point Int
}
