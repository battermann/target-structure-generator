module Models.MelodicForm exposing (MelodicForm(..), all, random, toString)

import Random


type MelodicForm
    = Period
    | Sequence
    | QuestionAnswer
    | SequenceInPeriod
    | PeriodInSequence


all : List MelodicForm
all =
    [ Period
    , Sequence
    , QuestionAnswer
    , SequenceInPeriod
    , PeriodInSequence
    ]


toString : MelodicForm -> String
toString melodicForm =
    case melodicForm of
        Period ->
            "Period"

        Sequence ->
            "Sequence"

        QuestionAnswer ->
            "Question/Answer"

        SequenceInPeriod ->
            "Sequence in Period"

        PeriodInSequence ->
            "Period in Sequence"


random : Random.Generator MelodicForm
random =
    Random.uniform Period
        [ Sequence
        , QuestionAnswer
        , SequenceInPeriod
        , PeriodInSequence
        ]
