module Utils exposing (..)
import Array exposing (..)
import Html exposing (..)
import Models exposing (..)
import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (required)

getElementByIndex : List Answer -> Int -> Answer
getElementByIndex list index =
  case list |> Array.fromList |> Array.get index of
    Just res -> res
    Nothing -> { content = "", color = "" }

getElementByIndexString : List String -> Int -> String
getElementByIndexString list index =
  case list |> Array.fromList |> Array.get index of
    Just res -> res
    Nothing -> ""

sliceList : Int -> Int -> List a -> List a
sliceList start end list =
  list |> Array.fromList |> (Array.slice start end) |> Array.toList

getColor : Int -> String -> Model -> String
getColor index content model =
  let
    input = content |> String.toLower
    airportCode = model.answer.ident |> String.toLower
  in
    if content == ""
      then "bg-slate-900"
    else if (input == (getElementByIndexString (airportCode |> String.split "") (index - (4 * (5 - model.tries)))))
      then "bg-green-500"
    else if (airportCode |> String.split "") |> List.any(\item -> (item |> String.toLower) == content)
      then "bg-yellow-500"
    else "bg-red-500"

getICAOCode : Cmd Msg
getICAOCode =
  Http.get
    { url = "https://airportle.vercel.app/api/"
    , expect = (Http.expectJson GotAirport airportDecoder)
    }

airportDecoder : Decoder Airport
airportDecoder =
  Decode.succeed Airport
    |> required "ident" string
    |> required "country" string
    |> required "name" string
    |> required "continent" string
    |> required "type_" string
