module Models.Metryx exposing (Metryx(..), all, beats, random, toString, tuple)

import Random


type Metryx
    = Metryx_3_2
    | Metryx_3_3
    | Metryx_3_4
    | Metryx_4_2
    | Metryx_4_3
    | Metryx_4_4
    | Metryx_5_2
    | Metryx_5_3
    | Metryx_5_4
    | Metryx_6_2
    | Metryx_7_2


all : List Metryx
all =
    [ Metryx_3_2
    , Metryx_3_3
    , Metryx_3_4
    , Metryx_4_2
    , Metryx_4_3
    , Metryx_4_4
    , Metryx_5_2
    , Metryx_5_3
    , Metryx_5_4
    , Metryx_6_2
    , Metryx_7_2
    ]


toString : Metryx -> String
toString metryx =
    case metryx of
        Metryx_3_2 ->
            "3-2"

        Metryx_3_3 ->
            "3-3"

        Metryx_3_4 ->
            "3-4"

        Metryx_4_2 ->
            "4-2"

        Metryx_4_3 ->
            "4-3"

        Metryx_4_4 ->
            "4-4"

        Metryx_5_2 ->
            "5-2"

        Metryx_5_3 ->
            "5-3"

        Metryx_5_4 ->
            "5-4"

        Metryx_6_2 ->
            "6-2"

        Metryx_7_2 ->
            "7-2"


random : Random.Generator Metryx
random =
    Random.uniform Metryx_3_2
        [ Metryx_3_3
        , Metryx_3_4
        , Metryx_4_2
        , Metryx_4_3
        , Metryx_4_4
        , Metryx_5_2
        , Metryx_5_3
        , Metryx_5_4
        , Metryx_6_2
        , Metryx_7_2
        ]


tuple : Metryx -> ( Int, Int )
tuple metryx =
    case metryx of
        Metryx_3_2 ->
            ( 3, 2 )

        Metryx_3_3 ->
            ( 3, 3 )

        Metryx_3_4 ->
            ( 3, 4 )

        Metryx_4_2 ->
            ( 4, 2 )

        Metryx_4_3 ->
            ( 4, 3 )

        Metryx_4_4 ->
            ( 4, 4 )

        Metryx_5_2 ->
            ( 5, 2 )

        Metryx_5_3 ->
            ( 5, 3 )

        Metryx_5_4 ->
            ( 5, 4 )

        Metryx_6_2 ->
            ( 6, 2 )

        Metryx_7_2 ->
            ( 7, 2 )


beats : Metryx -> Int
beats =
    tuple >> Tuple.first
