module Models exposing (..)

import Http exposing (..)

type Msg
  = Submit
  | UpdateList Int String
  | Restart
  | GotAirport (Result Http.Error Airport)


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

type alias Words =
  { redList: List String
  , yellowList: List String
  , greenList: List String
  }

type alias Model =
  { answer: Airport
  , tries: Int
  , wordList: List Answer
  , resultModal: WinState
  , wordStatus: Words
  }
