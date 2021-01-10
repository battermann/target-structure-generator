module MelodicForm exposing (MelodicForm(..), all, toString)


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
