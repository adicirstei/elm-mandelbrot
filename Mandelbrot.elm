module Mandelbrot
    exposing
        ( Model
        , init
        , view
        , computeCell
        , computeRow
        , computeAll
        )

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Complex exposing (Complex)


maxIterations =
    100


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
    , computed = Dict.empty |> Dict.insert ( 5, 5 ) 2
    }



-- z = z^2 + c


calculate : Int -> Complex -> Int -> Complex -> Maybe Int
calculate maxIterations c iteration z =
    let
        z' =
            Complex.mult z z
                |> Complex.add c
    in
        if iteration >= maxIterations then
            Nothing
        else if Complex.abs z' >= 2 then
            Just iteration
        else
            calculate maxIterations c (iteration + 1) z'


computeCell : Int -> Int -> Model -> Model
computeCell row col model =
    let
        c =
            Complex.complex
                (2 * toFloat col / toFloat model.width)
                (2 * toFloat row / toFloat model.height)

        value =
            calculate maxIterations c 0 c
    in
        case value of
            Just iterations ->
                { model | computed = Dict.insert ( col, row ) iterations model.computed }

            Nothing ->
                { model | computed = Dict.remove ( col, row ) model.computed }


computeRow : Int -> Model -> Model
computeRow row model =
    List.foldl (computeCell row) model [0..model.width]


computeAll : Model -> Model
computeAll model =
    List.foldl computeRow model [0..model.height]


view : Model -> Html msg
view model =
    div [ style [ ( "padding", "8px" ) ] ]
        (List.map (viewRow model) [0..model.height])


viewRow : Model -> Int -> Html msg
viewRow model row =
    div [ style [ ( "height", "2px" ) ] ]
        (List.map (viewCell model row) [0..model.width])


viewCell : Model -> Int -> Int -> Html msg
viewCell model row col =
    let
        color =
            case Dict.get ( col, row ) model.computed of
                Nothing ->
                    "black"

                _ ->
                    "yellow"
    in
        div
            [ style
                [ ( "width", "2px" )
                , ( "height", "2px" )
                , ( "background-color", color )
                , ( "display", "inline-block" )
                ]
            ]
            []
