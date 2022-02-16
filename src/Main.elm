module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Color
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))


main: Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }


type alias Answer =
  { content: String
  , color: String
  }

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , answer: Answer
  , tries: Int
  , wordList: List String
  }


init : Model
init =
  Model "" "" "" (Answer"LOWI" "Blank") 5 (List.repeat 4 "")


type Msg
  = Name String
  | Password String
  | PasswordAgain String
  | Submit


type Color
  = Blank
  | Red
  | Yellow
  | Green


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Submit ->
      model


view : Model -> Html Msg
view model =
  div [ class "w-screen min-h-screen flex flex-col items-center gap-5 bg-slate-800" ]
    [ div [ class "h-24 w-full px-10 md:px-20 flex flex-row text-4xl justify-between items-center bg-slate-900 text-white" ]
        [ span [ class "" ] [ text "Airportle" ]
        , button [] [ Outlined.info 40 Inherit ]
        , div [ class "absolute bg-black w-20 h-20 hidden" ] [ text "modal" ]
        ]
      , div [ class "flex flex-grow-[1] items-center justify-center flex-col gap-16 text-white" ]
        [ --(List.repeat (model.tries * 4) (viewBlock "test" Name))
          div [ class "grid grid-cols-4 gap-5" ] (model.wordList |> List.map (\_ -> viewBlock Name))
        , button [ onClick Submit, class "bg-slate-900 py-5 px-16 rounded-md hover:shadow-2xl hover:shadow-slate-900 active:shadow-none" ]
            [ text "Submit" ]
        ]
    ]

viewBlock : (String -> msg) -> Html msg
viewBlock toMsg =
  input [ maxlength 1, class "bg-slate-900 text-white w-16 h-16 md:w-20 md:h-20 rounded-md text-5xl text-center uppercase" ]
    []


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg, class "bg-red-900" ] []


viewValidation : Model -> Html msg
viewValidation model =
  if model.password == model.passwordAgain then
    div [ class "" ] [ text "OK" ]
  else
    div [ ] [ text "Passwords do not match!" ]
