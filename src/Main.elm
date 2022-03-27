module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Models exposing (..)
import Utils exposing (getColor, getICAOCode, getElementByIndex, sliceList)


main: Program () Model Msg
main =
  Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }

init : () -> (Model, Cmd Msg)
init _ =
  ( { answer =
      { ident = "ident"
      , country= "country"
      , name= "name"
      , continent= "continent"
      , type_= "type"
      }
    , tries = 5
    , wordList = (List.repeat 4 (Answer "" "bg-slate-900"))
    , resultState = Neutral
    , infoModalState = Hidden
    }
  , getICAOCode
  )

checkIfWin : Model -> WinState
checkIfWin model =
  let
    airportCode = model.answer.ident |> String.toLower
    lowerLimit = 4 * (5 - model.tries)
    upperLimit = 4 * (6 - model.tries)
  in
    if ( model.wordList
         |> (sliceList lowerLimit upperLimit)
         |> List.map (\i -> i.content |> String.toLower)
         |> String.join ""
       ) == airportCode then
      Win
    else if model.tries == 1 then
      Lose
    else
      Neutral

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    lowerLimit = 4 * (5 - model.tries)
    upperLimit = 4 * (6 - model.tries)
  in
    case msg of
      Submit ->
        ( { model
            | wordList = model.wordList ++ List.repeat 4 (Answer "" "bg-slate-900")
            |> List.indexedMap (\index item ->
              if (index >= lowerLimit && index < upperLimit && not (item.content == "")) then { item | color = (getColor index item.content model) } else item)
          , tries = if model.wordList |> List.all (\item -> item.color == "bg-green-500") then model.tries else model.tries - 1
          , resultState = checkIfWin model
          }
        , Cmd.none
        )
      UpdateList index content ->
        ( { model
            | wordList = model.wordList
            |> List.indexedMap (\i item -> if (i == index && i >= lowerLimit && i < upperLimit) then { item | content = content } else item)
          }
        , Cmd.none
        )
      Restart ->
        ( { model
            | tries = 5
            , wordList = (List.repeat 4 (Answer "" "bg-slate-900"))
            , resultState = Neutral
            , infoModalState = Hidden
          }
        , getICAOCode
        )
      GotAirport result ->
        case result of
            Ok airport ->
              ( { model | answer = airport }
              , Cmd.none
              )
            Err _ -> ( model, Cmd.none )
      SetInfoModalState state ->
        ( { model | infoModalState = state } , Cmd.none)

view : Model -> Html Msg
view model =
  div [ class "min-h-screen flex flex-col gap-10 bg-slate-800" ]
    [ viewInfoModal model
      , div [ class (modalVisibility model ++ "fixed backdrop-blur-2xl w-screen h-screen flex items-center justify-center") ]
        [ div [ class "px-16 py-10 md:px-40 md:py-24 bg-slate-900 rounded-md flex flex-col gap-16 text-white text-3xl" ]
          [ span [ class "text-center" ] [ text ("Answer: " ++ model.answer.ident) ]
          , button [ onClick Restart, class "px-2 py-3 bg-slate-600 rounded-md" ] [ text (modalText model) ] ]
        ] -- ResultModal
      , header [ class "h-24 w-full px-10 md:px-20 flex flex-row text-4xl justify-between items-center bg-slate-900 text-white" ]
        [ span [ class "" ] [ text "Airportle" ]
        , div [ class "flex items-center gap-2" ]
          [ button
              [ onClick (SetInfoModalState Reset)
              , attribute "role" "presentation"
              , attribute "aria-label" "Restart button"
              ]
              [ Outlined.restart_alt 40 Inherit ]
          , button
              [ onClick (SetInfoModalState Info)
              , attribute "role" "presentation"
              , attribute "aria-label" "Information button"
              ]
              [ Outlined.info 40 Inherit ]
          ]
        ] -- Header
      , main_ [ class "flex flex-grow-[1] items-center justify-center flex-col gap-20 text-white my-5" ]
        [ div [ class "grid grid-cols-4 gap-5" ]
          (model.wordList |> List.indexedMap (\index item -> viewInputBlock index item.color model))
        , button [ onClick Submit, class "bg-slate-900 py-5 px-16 rounded-md hover:shadow-2xl text-xl hover:shadow-slate-900 active:shadow-none" ]
            [ text "Submit" ]
        ] -- Main
    ]

viewInputBlock : Int -> String -> Model -> Html Msg
viewInputBlock index color model =
  let
    lowerLimit = 4 * (5 - model.tries)
    upperLimit = 4 * (6 - model.tries)
  in
    input
      [ onInput (UpdateList index)
      , maxlength 1
      , value (getElementByIndex model.wordList index).content
      , attribute (if index >= lowerLimit && index < upperLimit then "none" else "disabled") ""
      , attribute "aria-label" "Input block"
      , class (color ++ " text-white w-16 h-16 md:w-20 md:h-20 rounded-md text-5xl text-center uppercase")
      ]
      []

viewInfoModal : Model -> Html Msg
viewInfoModal model =
  let
    visibility =
      case model.infoModalState of
        Hidden -> "hidden "
        _ -> ""

    contentText =
      case model.infoModalState of
        Reset -> "Restart the game?"
        Info -> """
        Welcome to Airportle, Wordle for ICAO codes.\n
        ICAO codes are 4 letter words given to airports.\n
        Only alphabets are allowed in this game.\n
        Red indicates wrong, Yellow - off position, Green - correct.\n
        You have 5 tries to win the game.\n
        Answers change each try.
        """
        _ -> ""

    buttonFunctionality =
      case model.infoModalState of
        Reset -> Restart
        _ -> SetInfoModalState Hidden

    buttonText =
      case model.infoModalState of
          Reset -> "Restart"
          _ -> "Understood"
  in
    div [ class (visibility++ "fixed backdrop-blur-2xl w-screen h-screen flex items-center justify-center") ]
        [ div [ class "mx-10 px-8 py-10 md:px-40 md:py-24 bg-slate-900 rounded-md flex flex-col gap-8 md:gap-16 text-white text-2xl md:text-3xl max-h-[90%]" ]
          [ span [ class "text-center overflow-y-auto whitespace-pre-line" ] [ text contentText ]
          , button [ onClick buttonFunctionality, class "px-2 py-3 bg-slate-600 rounded-md" ] [ text buttonText] ]
        ]


modalVisibility : Model -> String
modalVisibility model =
  case model.resultState of
    Neutral -> "hidden "
    _ -> ""

modalText : Model -> String
modalText model =
  case model.resultState of
    Win -> "You Won!"
    Lose -> "You Lost!"
    Neutral -> ""

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
