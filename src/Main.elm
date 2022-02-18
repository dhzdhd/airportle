module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Array
import Random.List exposing (choose)
import Random exposing (generate)
import Http


main: Program String Model Msg
main =
  Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


type alias Answer =
  { content: String
  , color: String
  }

type alias Model =
  { answer: String
  , tries: Int
  , wordList: List Answer
  , resultModal: Bool
  }


getICAOCode : String
getICAOCode =
  -- Http.get {}
  "LOWI"


init : flags -> (Model, Cmd Msg)
init _ =
  ({ answer = getICAOCode
  , tries = 5
  , wordList = (List.repeat 4 (Answer "" "bg-slate-900"))
  , resultModal = False
  }, Cmd.none )


type Msg
  = Submit
  | UpdateList Int String


getElementByIndex : List String -> Int -> String
getElementByIndex list index =
  case list |> Array.fromList |> Array.get index of
    Just res -> res
    Nothing -> ""


getColor : Int -> String -> Model -> String
getColor index content model =
  if content == ""
    then "bg-slate-900"
  else if (content == (getElementByIndex (model.answer |> String.toLower |> String.split "") index))
    then "bg-green-500"
  else if (model.answer |> String.split "") |> List.any(\item -> (item |> String.toLower) == content)
    then "bg-yellow-500"
  else "bg-red-500"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Submit ->
      ({ model
        | wordList = model.wordList
        |> List.indexedMap (\index item -> { item | color = (getColor index item.content model) })
        , tries = if model.wordList |> List.all (\item -> item.color == "bg-green-500") then model.tries else model.tries - 1
      }
      , Cmd.none
      )
    UpdateList index content ->
      ({ model
        | wordList = model.wordList
        |> List.indexedMap (\i item -> if i == index then { item | color = "bg-slate-900", content = content } else item)
      }
      , Cmd.none
      )


view : Model -> Html Msg
view model =
  div [ class "w-screen min-h-screen flex flex-col items-center gap-5 bg-slate-800" ]
    [ div [ class "hidden absolute w-screen h-screen flex items-center justify-center" ]
        [ div [ class "px-96 py-48 bg-slate-900 rounded-md flex flex-col gap-16 text-white text-4xl" ]
          [ span [ class "text-center" ] [ text "Tries : " ]
          , button [ class "px-20 py-10 bg-slate-600 rounded-md" ] [ text "You win!" ] ]
        ]
      , div [ class "h-24 w-full px-10 md:px-20 flex flex-row text-4xl justify-between items-center bg-slate-900 text-white" ]
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

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
