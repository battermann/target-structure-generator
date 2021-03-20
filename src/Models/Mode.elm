module Models.Mode exposing (Mode(..), all, random, toString)

import Random


type Mode
    = Ionian
    | Dorian
    | Phrygian
    | Lydian
    | Mixolydian
    | Aeolian


all : List Mode
all =
    [ Ionian
    , Dorian
    , Phrygian
    , Lydian
    , Mixolydian
    , Aeolian
    ]


toString : Mode -> String
toString mode =
    case mode of
        Ionian ->
            "Ionian"

        Dorian ->
            "Dorian"

        Phrygian ->
            "Phrygian"

        Lydian ->
            "Lydian"

        Mixolydian ->
            "Mixolydian"

        Aeolian ->
            "Aeolian"


random : Random.Generator Mode
random =
    Random.uniform Ionian
        [ Dorian
        , Phrygian
        , Lydian
        , Mixolydian
        , Aeolian
        ]
