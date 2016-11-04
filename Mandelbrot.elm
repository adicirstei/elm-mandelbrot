module Mandelbrot
    exposing
        ( Model
        , init
        , view
        , computeCell
        , computeRow
        , computeAll
        , complexFromGridModel
        )

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Complex exposing (Complex)


maxIterations =
    50


type alias Point =
    ( Int, Int )


type alias Model =
    { width : Int
    , height : Int
    , computed : Dict Point Int
    , min : Complex
    , max : Complex
    }


init : Int -> Model
init size =
    { width = size
    , height = size
    , computed = Dict.empty
    , min = Complex.complex -2 -1.5
    , max = Complex.complex 1 1.5
    }



-- z = z^2 + c


calculate : Int -> Complex -> Int -> Complex -> Maybe Int
calculate maxIterations c iteration z =
    let
        -- az =
        --     Complex.complex
        --         (abs z.re)
        --         (abs z.im)
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


complexFromGridModel : Int -> Int -> Model -> Complex
complexFromGridModel row col model =
    let
        colPercent =
            toFloat col / toFloat model.width

        rowPercent =
            toFloat row / toFloat model.height
    in
        Complex.complex
            (model.min.re + (model.max.re - model.min.re) * colPercent)
            (model.min.im + (model.max.im - model.min.im) * rowPercent)


computeCell : Int -> Int -> Model -> Model
computeCell row col model =
    let
        c =
            complexFromGridModel row col model

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


view : (( Int, Int ) -> msg) -> Model -> Html msg
view msgFn model =
    div
        [ style
            [ ( "padding", "8px" )
            ]
        ]
        (List.map (viewRow msgFn model) [0..model.height])


viewRow : (( Int, Int ) -> msg) -> Model -> Int -> Html msg
viewRow msgFn model row =
    div [ style [ ( "height", "2px" ) ] ]
        (List.map (viewCell msgFn model row) [0..model.width])


determineColor : Int -> String
determineColor i =
    let
        x =
            i % 50
    in
        "rgb(" ++ toString (200 + x) ++ "," ++ toString (x * 2) ++ ", " ++ toString (x * 5) ++ ")"


viewCell : (( Int, Int ) -> msg) -> Model -> Int -> Int -> Html msg
viewCell msgFn model row col =
    let
        color =
            Dict.get ( col, row ) model.computed
                |> Maybe.map determineColor
                |> Maybe.withDefault "black"
    in
        div
            [ style
                [ ( "width", "2px" )
                , ( "height", "2px" )
                , ( "background-color", color )
                , ( "display", "inline-block" )
                , ( "border", "none" )
                , ( "vertical-align", "top" )
                ]
            , onClick (msgFn ( col, row ))
            ]
            []
