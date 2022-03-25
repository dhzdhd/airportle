module Utils exposing (..)
import Array exposing (..)
import Html exposing (..)
-- import Html.Attributes exposing ()
import Models exposing (..)
import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, decodeString, float, int, nullable, string, map5)
import Json.Decode.Pipeline exposing (required, optional, hardcoded)


getElementByIndex : List String -> Int -> String
getElementByIndex list index =
  case list |> Array.fromList |> Array.get index of
    Just res -> res
    Nothing -> ""


getColor : Int -> String -> Model -> String
getColor index content model =
  let
    text = content |> String.toLower
    code = model.answer.ident |> String.toLower
  in
    if content == ""
      then "bg-slate-900"
    else if (text == (getElementByIndex (code |> String.split "") index))
      then "bg-green-500"
    else if (code |> String.split "") |> List.any(\item -> (item |> String.toLower) == content)
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
