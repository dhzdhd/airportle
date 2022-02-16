module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main: Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }


type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , tries: Int
  , wordList: List String
  }


init : Model
init =
  Model "" "" "" 5 (List.repeat 4 "")


type Msg
  = Name String
  | Password String
  | PasswordAgain String


type Color
  = Red
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


view : Model -> Html Msg
view model =
  div [ class "w-screen h-screen flex flex-col items-center justify-center gap-5 bg-slate-800" ]
    [ span [ class "text-7xl text-white pb-20" ] [ text "Airportle"]
    --, div [ class "grid grid-cols-4 gap-5" ] (List.repeat (model.tries * 4) (viewBlock "test" Name))
    , div [ class "grid grid-cols-4 gap-5" ] (model.wordList |> (List.map (\_ -> viewBlock "test" Name)))
    , div [] [ text "hello" ]
    ]


viewBlock : String -> (String -> msg) -> Html msg
viewBlock word toMsg =
    button [ class "bg-slate-900 text-white w-20 h-20 rounded-md hover:animate-pulse" ]
      [ text word ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg, class "bg-red-900" ] []


viewValidation : Model -> Html msg
viewValidation model =
  if model.password == model.passwordAgain then
    div [ class "" ] [ text "OK" ]
  else
    div [ ] [ text "Passwords do not match!" ]
