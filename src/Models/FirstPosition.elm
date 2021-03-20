module Models.FirstPosition exposing (FirstPosition(..), all, random, toString)

import Random


type FirstPosition
    = Open
    | Closed


all : List FirstPosition
all =
    [ Open, Closed ]


toString : FirstPosition -> String
toString firstPosition =
    case firstPosition of
        Open ->
            "Open"

        Closed ->
            "Closed"


random : Random.Generator FirstPosition
random =
    Random.uniform Open [ Closed ]
