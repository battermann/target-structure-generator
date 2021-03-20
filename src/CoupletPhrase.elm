module CoupletPhrase exposing (CoupletPhrase(..), all, random, toString)

import Random


type CoupletPhrase
    = AB
    | ABAB
    | AABB
    | AAAB
    | ABBB
    | BABA
    | BBAA
    | AAB
    | ABB


all : List CoupletPhrase
all =
    [ AB
    , ABAB
    , AABB
    , AAAB
    , ABBB
    , BABA
    , BBAA
    , AAB
    , ABB
    ]


toString : CoupletPhrase -> String
toString coupletPhrase =
    case coupletPhrase of
        AB ->
            "AB"

        ABAB ->
            "ABAB"

        AABB ->
            "AABB"

        AAAB ->
            "AAAB"

        ABBB ->
            "ABBB"

        BABA ->
            "BABA"

        BBAA ->
            "BBAA"

        AAB ->
            "AAB"

        ABB ->
            "ABB"


random : Random.Generator CoupletPhrase
random =
    Random.uniform AB all
