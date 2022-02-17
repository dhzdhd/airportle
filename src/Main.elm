module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Array


main: Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }


type alias Answer =
  { content: String
  , color: String
  }

type alias Model =
  { answer: String
  , tries: Int
  , wordList: List Answer
  }


getICAOCode : String
getICAOCode =
  "heh"


init : Model
init =
  Model "LOWI" 5 (List.repeat 4 (Answer "" "bg-slate-900"))


type Msg
  = Submit
  | UpdateList Int String


getElementByIndex : List Answer -> Int -> String
getElementByIndex list index =
  case list |> Array.fromList |> Array.get index of
    Just res -> res.content
    Nothing -> ""


getColor : Int -> String -> Model -> String
getColor index content model =
  if (content == (getElementByIndex model.wordList index)) then "bg-green-500" else "bg-green-500"


update : Msg -> Model -> Model
update msg model =
  case msg of
    Submit ->
      { model
        | wordList = model.wordList
        |> List.indexedMap (\index item -> { item | color = (getColor index item.content model) })
        , tries = if model.wordList |> List.all (\item -> item.color == "bg-green-500") then model.tries else model.tries - 1
      }
    UpdateList index content ->
      { model
        | wordList = model.wordList
        |> List.indexedMap (\i item -> if i == index then { item | color = "bg-slate-900", content = content } else item)
      }


view : Model -> Html Msg
view model =
  div [ class "w-screen min-h-screen flex flex-col items-center gap-5 bg-slate-800" ]
    [ div [ class "h-24 w-full px-10 md:px-20 flex flex-row text-4xl justify-between items-center bg-slate-900 text-white" ]
        [ span [ class "" ] [ text "Airportle" ]
        , button [] [ Outlined.info 40 Inherit ]
        , div [ class "absolute bg-black w-20 h-20 hidden" ] [ text "modal" ]
        ]
      , div [ class "flex flex-grow-[1] items-center justify-center flex-col gap-16 text-white" ]
        [ div [ class "grid grid-cols-4 gap-5" ] (model.wordList |> List.indexedMap (\index item -> viewBlock index item.color))
        , button [ onClick Submit, class "bg-slate-900 py-5 px-16 rounded-md hover:shadow-2xl hover:shadow-slate-900 active:shadow-none" ]
            [ text "Submit" ]
        ]
    ]

viewBlock : Int -> String -> Html Msg
viewBlock index color =
  input [ onInput (UpdateList index), maxlength 1, class (color ++ " text-white w-16 h-16 md:w-20 md:h-20 rounded-md text-5xl text-center uppercase") ]
    []


-- viewInput : String -> String -> String -> (String -> msg) -> Html msg
-- viewInput t p v toMsg =
--   input [ type_ t, placeholder p, value v, onInput toMsg, class "bg-red-900" ] []


-- viewValidation : Model -> Html msg
-- viewValidation model =
--   if model.password == model.passwordAgain then
--     div [ class "" ] [ text "OK" ]
--   else
--     div [ ] [ text "Passwords do not match!" ]
