module Models.PolyMetryx exposing (PolyMetryx, all, random, toMultiLineString)

import Arithmetic
import Models.Metryx as Metryx exposing (Metryx(..))
import Random


type alias PolyMetryx =
    ( Metryx, Metryx )


all : List PolyMetryx
all =
    [ ( Metryx_3_2, Metryx_3_3 )
    , ( Metryx_3_2, Metryx_3_4 )
    , ( Metryx_3_2, Metryx_4_2 )
    , ( Metryx_3_2, Metryx_4_3 )
    , ( Metryx_3_2, Metryx_4_4 )
    , ( Metryx_3_2, Metryx_5_2 )
    , ( Metryx_3_2, Metryx_5_3 )
    , ( Metryx_3_2, Metryx_5_4 )
    , ( Metryx_3_3, Metryx_3_4 )
    , ( Metryx_3_3, Metryx_4_2 )
    , ( Metryx_3_3, Metryx_4_3 )
    , ( Metryx_3_3, Metryx_5_3 )
    , ( Metryx_3_4, Metryx_4_2 )
    , ( Metryx_3_4, Metryx_4_3 )
    , ( Metryx_3_4, Metryx_5_3 )
    , ( Metryx_3_4, Metryx_5_4 )
    , ( Metryx_3_4, Metryx_6_2 )
    , ( Metryx_4_2, Metryx_4_3 )
    , ( Metryx_4_2, Metryx_4_4 )
    , ( Metryx_4_2, Metryx_5_2 )
    , ( Metryx_4_2, Metryx_5_4 )
    , ( Metryx_4_3, Metryx_4_4 )
    , ( Metryx_4_3, Metryx_5_2 )
    , ( Metryx_4_3, Metryx_5_4 )
    , ( Metryx_4_3, Metryx_6_2 )
    , ( Metryx_4_4, Metryx_5_4 )
    , ( Metryx_4_4, Metryx_6_2 )
    , ( Metryx_5_2, Metryx_5_3 )
    , ( Metryx_5_2, Metryx_5_4 )
    , ( Metryx_5_2, Metryx_6_2 )
    , ( Metryx_5_3, Metryx_5_4 )
    , ( Metryx_5_3, Metryx_6_2 )
    , ( Metryx_5_4, Metryx_6_2 )
    ]


toMultiLineString : PolyMetryx -> List String
toMultiLineString ( fst, snd ) =
    let
        ( numBeatsFst, durationFst ) =
            Metryx.tuple fst

        ( numBeatsSnd, durationSnd ) =
            Metryx.tuple snd

        gcd =
            Arithmetic.gcd (numBeatsFst * durationFst) (numBeatsSnd * durationSnd)
    in
    [ Metryx.toString fst ++ "=" ++ String.fromInt ((numBeatsSnd * durationSnd) // gcd)
    , Metryx.toString snd ++ "=" ++ String.fromInt ((numBeatsFst * durationFst) // gcd)
    ]


random : Random.Generator PolyMetryx
random =
    Random.uniform
        ( Metryx_3_2, Metryx_3_3 )
        [ ( Metryx_3_2, Metryx_3_4 )
        , ( Metryx_3_2, Metryx_4_2 )
        , ( Metryx_3_2, Metryx_4_3 )
        , ( Metryx_3_2, Metryx_4_4 )
        , ( Metryx_3_2, Metryx_5_2 )
        , ( Metryx_3_2, Metryx_5_3 )
        , ( Metryx_3_2, Metryx_5_4 )
        , ( Metryx_3_3, Metryx_3_4 )
        , ( Metryx_3_3, Metryx_4_2 )
        , ( Metryx_3_3, Metryx_4_3 )
        , ( Metryx_3_3, Metryx_5_3 )
        , ( Metryx_3_4, Metryx_4_2 )
        , ( Metryx_3_4, Metryx_4_3 )
        , ( Metryx_3_4, Metryx_5_3 )
        , ( Metryx_3_4, Metryx_5_4 )
        , ( Metryx_3_4, Metryx_6_2 )
        , ( Metryx_4_2, Metryx_4_3 )
        , ( Metryx_4_2, Metryx_4_4 )
        , ( Metryx_4_2, Metryx_5_2 )
        , ( Metryx_4_2, Metryx_5_4 )
        , ( Metryx_4_3, Metryx_4_4 )
        , ( Metryx_4_3, Metryx_5_2 )
        , ( Metryx_4_3, Metryx_5_4 )
        , ( Metryx_4_3, Metryx_6_2 )
        , ( Metryx_4_4, Metryx_5_4 )
        , ( Metryx_4_4, Metryx_6_2 )
        , ( Metryx_5_2, Metryx_5_3 )
        , ( Metryx_5_2, Metryx_5_4 )
        , ( Metryx_5_2, Metryx_6_2 )
        , ( Metryx_5_3, Metryx_5_4 )
        , ( Metryx_5_3, Metryx_6_2 )
        , ( Metryx_5_4, Metryx_6_2 )
        ]
