module Models.MelodicFormPlus exposing (MelodicForm(..), all, random, toString)

import Random


type MelodicForm
    = Period
    | Sequence
    | QuestionAnswer


all : List MelodicForm
all =
    [ Period, Sequence, QuestionAnswer ]


toString : MelodicForm -> String
toString melodicForm =
    case melodicForm of
        Period ->
            "Period"

        Sequence ->
            "Sequence"

        QuestionAnswer ->
            "Q/A"


random : Random.Generator MelodicForm
random =
    Random.uniform Period [ Sequence, QuestionAnswer ]
