module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Array


main: Program Airport Model Msg
main =
  Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


type alias Airport =
  { ident: String
  , country: String
  , name: String
  , continent: String
  , aType: String
  }

type alias Answer =
  { content: String
  , color: String
  }

type alias Model =
  { answer: Airport
  , tries: Int
  , wordList: List Answer
  , resultModal: WinState
  }


getICAOCode : String
getICAOCode =
  -- Http.get {}
  "LOWI"


init : Airport -> (Model, Cmd Msg)
init airport =
  ( { answer = airport
    , tries = 5
    , wordList = (List.repeat 4 (Answer "" "bg-slate-900"))
    , resultModal = Neutral
    }
  , Cmd.none
  )


type Msg
  = Submit
  | UpdateList Int String
  | Restart

type WinState
  = Win
  | Lose
  | Neutral

getElementByIndex : List String -> Int -> String
getElementByIndex list index =
  case list |> Array.fromList |> Array.get index of
    Just res -> res
    Nothing -> ""


getColor : Int -> String -> Model -> String
getColor index content model =
  if content == ""
    then "bg-slate-900"
  else if (content == (getElementByIndex (model.answer.ident |> String.toLower |> String.split "") index))
    then "bg-green-500"
  else if (model.answer.ident |> String.split "") |> List.any(\item -> (item |> String.toLower) == content)
    then "bg-yellow-500"
  else "bg-red-500"


checkIfWin : Model -> WinState
checkIfWin model =
  if (model.wordList |> List.map (\i -> i.content |> String.toLower ) |> String.join "") == (model.answer.ident |> String.toLower) then
    Win
  else if model.tries == 0 then
    Lose
  else
    Neutral

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Submit ->
      ( { model
          | wordList = model.wordList
          |> List.indexedMap (\index item -> { item | color = (getColor index item.content model) })
        , tries = if model.wordList |> List.all (\item -> item.color == "bg-green-500") then model.tries else model.tries - 1
        , resultModal = checkIfWin model
        }
      , Cmd.none
      )
    UpdateList index content ->
      ( { model
          | wordList = model.wordList
          |> List.indexedMap (\i item -> if i == index then { item | color = "bg-slate-900", content = content } else item)
        }
      , Cmd.none
      )
    Restart ->
      ( { model
          | tries = 5
          , wordList = (List.repeat 4 (Answer "" "bg-slate-900"))
          , resultModal = Neutral
        }
      , Cmd.none
      )


view : Model -> Html Msg
view model =
  div [ class "w-screen min-h-screen flex flex-col items-center gap-5 bg-slate-800" ]
    [ div [ class (showModal model ++ "absolute w-screen h-screen flex items-center justify-center") ]
        [ div [ class "px-80 py-32 bg-slate-900 rounded-md flex flex-col gap-16 text-white text-4xl" ]
          [ span [ class "text-center" ] [ text ("Answer: " ++ model.answer.ident) ]
          , button [ onClick Restart, class "px-16 py-7 bg-slate-600 rounded-md" ] [ text (modalText model) ] ]
        ]
      , div [ class "h-24 w-full px-10 md:px-20 flex flex-row text-4xl justify-between items-center bg-slate-900 text-white" ]
        [ span [ class "" ] [ text "Airportle" ]
        , button [] [ Outlined.info 40 Inherit ]
        , div [ class "absolute bg-black w-20 h-20 hidden" ] [ text "modal" ]
        ]
      , div [ class "flex flex-grow-[1] items-center justify-center flex-col gap-16 text-white" ]
        [ div [ class "grid grid-cols-4 gap-5" ] (model.wordList |> List.indexedMap (\index item -> viewBlock index item.color))
        , button [ onClick Submit, class "bg-slate-900 py-5 px-16 rounded-md hover:shadow-2xl text-xl hover:shadow-slate-900 active:shadow-none" ]
            [ text "Submit" ]
        ]
    ]

showModal : Model -> String
showModal model =
  case model.resultModal of
  Neutral -> "hidden "
  _ -> ""

modalText : Model -> String
modalText model =
  case model.resultModal of
  Win -> "You Won!"
  Lose -> "You Lost!"
  Neutral -> ""


viewBlock : Int -> String -> Html Msg
viewBlock index color =
  input [ onInput (UpdateList index),  maxlength 1, class (color ++ " text-white w-16 h-16 md:w-20 md:h-20 rounded-md text-5xl text-center uppercase") ]
    []

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
