module Models exposing (..)

import Http exposing (..)

type InfoModalState
  = Reset
  | Info
  | Loading
  | Hidden

type Msg
  = Submit
  | UpdateList Int String
  | Restart
  | GotAirport (Result Http.Error Airport)
  | SetInfoModalState InfoModalState
  | NoOp

type WinState
  = Win
  | Lose
  | Neutral

type alias Airport =
  { ident: String
  , country: String
  , name: String
  , continent: String
  , type_: String
  }

type alias Answer =
  { content: String
  , color: String
  }

type alias Model =
  { answer: Airport
  , tries: Int
  , wordList: List Answer
  , resultState: WinState
  , infoModalState: InfoModalState
  }
