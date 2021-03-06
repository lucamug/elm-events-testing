module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Mouse
import Keyboard
import Regex
import Char
import Keyboard.Extra exposing (Key(..))


-- MODEL


type alias Model =
    { mouseClicks : Mouse.Position
    , mouseMoves : Mouse.Position
    , mouseDowns : Mouse.Position
    , mouseUps : Mouse.Position
    , keyboardPresses : Int
    , keyboardDowns : Int
    , keyboardUps : Int
    , keyboardPressesChar : Char
    , eventClick : Int
    , eventDoubleClick : Int
    , eventMouseDown : Int
    , eventMouseUp : Int
    , eventMouseEnter : Int
    , eventMouseLeave : Int
    , eventMouseOver : Int
    , eventMouseOut : Int
    , pressedKeys : List Key
    }


init : ( Model, Cmd Msg )
init =
    ( { mouseClicks = { x = 0, y = 0 }
      , mouseMoves = { x = 0, y = 0 }
      , mouseDowns = { x = 0, y = 0 }
      , mouseUps = { x = 0, y = 0 }
      , keyboardPresses = 0
      , keyboardDowns = 0
      , keyboardUps = 0
      , keyboardPressesChar = ' '
      , eventClick = 0
      , eventDoubleClick = 0
      , eventMouseDown = 0
      , eventMouseUp = 0
      , eventMouseEnter = 0
      , eventMouseLeave = 0
      , eventMouseOver = 0
      , eventMouseOut = 0
      , pressedKeys = []
      }
    , Cmd.none
    )



-- MESSAGES


type Msg
    = MouseClicks Mouse.Position
    | MouseMoves Mouse.Position
    | MouseDowns Mouse.Position
    | MouseUps Mouse.Position
    | KeyboardPresses Keyboard.KeyCode
    | KeyboardDowns Keyboard.KeyCode
    | KeyboardUps Keyboard.KeyCode
    | EventClick
    | EventDoubleClick
    | EventMouseDown
    | EventMouseUp
    | EventMouseEnter
    | EventMouseLeave
    | EventMouseOver
    | EventMouseOut
    | KeyboardMsg Keyboard.Extra.Msg



-- VIEW


view : Model -> Html Msg
view model =
    let
        shiftPressed =
            List.member Shift model.pressedKeys

        arrows =
            Keyboard.Extra.arrows model.pressedKeys

        wasd =
            Keyboard.Extra.wasd model.pressedKeys

        formatted =
            model
                |> toString
                |> Regex.replace Regex.All (Regex.regex ", m") (\_ -> "\n, m")
                |> Regex.replace Regex.All (Regex.regex ", k") (\_ -> "\n, k")
                |> Regex.replace Regex.All (Regex.regex ", e") (\_ -> "\n, e")
                |> Regex.replace Regex.All (Regex.regex ", p") (\_ -> "\n, p")
                |> Regex.replace Regex.All (Regex.regex "}$") (\_ -> "\n}")
    in
        pre
            [ onClick EventClick
            , onDoubleClick EventDoubleClick
            , onMouseDown EventMouseDown
            , onMouseUp EventMouseUp
            , onMouseEnter EventMouseEnter
            , onMouseLeave EventMouseLeave
            , onMouseOver EventMouseOver
            , onMouseOut EventMouseOut
            , style
                [ ( "position", "absolute" )
                , ( "margin", "0px" )
                , ( "padding", "10px" )
                , ( "background-color", "orange" )
                , ( "width", "100%" )
                , ( "height", "100%" )
                ]
            ]
            [ text formatted
            , pre [] [ text ("shiftPressed: " ++ toString shiftPressed) ]
            , pre [] [ text ("arrows: " ++ toString arrows) ]
            , pre [] [ text ("wasd: " ++ toString wasd) ]
            , div [] [ a [ href "https://medium.com/@l.mugnaini/elm-events-testing-a812dfbcb21" ] [ text "Post: https://medium.com/@l.mugnaini/elm-events-testing-a812dfbcb21" ] ]
            , div [] [ a [ href "https://github.com/lucamug/elm-events-testing/blob/master/main.elm" ] [ text "Code: https://github.com/lucamug/elm-events-testing/blob/master/main.elm" ] ]
            , div
                [ style
                    [ ( "position", "absolute" )
                    , ( "font-size", "10em" )
                    , ( "cursor", "default" )
                    , ( "transform", "translate(-50%, -50%)" )
                    , ( "top", toString (model.mouseMoves.y) ++ "px" )
                    , ( "left", toString (model.mouseMoves.x) ++ "px" )
                    ]
                ]
                [ text "◎" ]
            ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseClicks position ->
            ( { model | mouseClicks = position }, Cmd.none )

        MouseMoves position ->
            ( { model | mouseMoves = position }, Cmd.none )

        MouseDowns position ->
            ( { model | mouseDowns = position }, Cmd.none )

        MouseUps position ->
            ( { model | mouseUps = position }, Cmd.none )

        KeyboardPresses code ->
            ( { model | keyboardPresses = code, keyboardPressesChar = Char.fromCode code }, Cmd.none )

        KeyboardDowns code ->
            ( { model | keyboardDowns = code }, Cmd.none )

        KeyboardUps code ->
            ( { model | keyboardUps = code }, Cmd.none )

        EventClick ->
            ( { model | eventClick = model.eventClick + 1 }, Cmd.none )

        EventDoubleClick ->
            ( { model | eventDoubleClick = model.eventDoubleClick + 1 }, Cmd.none )

        EventMouseDown ->
            ( { model | eventMouseDown = model.eventMouseDown + 1 }, Cmd.none )

        EventMouseUp ->
            ( { model | eventMouseUp = model.eventMouseUp + 1 }, Cmd.none )

        EventMouseEnter ->
            ( { model | eventMouseEnter = model.eventMouseEnter + 1 }, Cmd.none )

        EventMouseLeave ->
            ( { model | eventMouseLeave = model.eventMouseLeave + 1 }, Cmd.none )

        EventMouseOver ->
            ( { model | eventMouseOver = model.eventMouseOver + 1 }, Cmd.none )

        EventMouseOut ->
            ( { model | eventMouseOut = model.eventMouseOut + 1 }, Cmd.none )

        KeyboardMsg keyMsg ->
            ( { model
                | pressedKeys = Keyboard.Extra.update keyMsg model.pressedKeys
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks MouseClicks
        , Mouse.moves MouseMoves
        , Mouse.downs MouseDowns
        , Mouse.ups MouseUps
        , Keyboard.presses KeyboardPresses
        , Keyboard.downs KeyboardDowns
        , Keyboard.ups KeyboardUps
        , Sub.map KeyboardMsg Keyboard.Extra.subscriptions
        ]



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
