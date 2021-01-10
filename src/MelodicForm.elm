module MelodicForm exposing (MelodicForm(..), all, random, toString)

import Random


type MelodicForm
    = Period
    | Sequence


all : List MelodicForm
all =
    [ Period, Sequence ]


toString : MelodicForm -> String
toString melodicForm =
    case melodicForm of
        Period ->
            "Period"

        Sequence ->
            "Sequence"


random : Random.Generator MelodicForm
random =
    Random.uniform Period all
