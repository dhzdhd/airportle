module Utils exposing (..)
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Model)


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
