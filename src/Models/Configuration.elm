module Models.Configuration exposing (Configuration(..), all, random, toMultiLineString)

import Random


type Configuration
    = MelodyMotifMotorAnchor
    | MelodyMelodyHarmonyMotorAnchor
    | MelodyMelodyHarmonyMelodyHarmonyAnchor
    | MelodyMelodyHarmonyMelodyHarmonyMelodyHarmony
    | MelodyMotorHarmonyMotorAnchor
    | MelodyAnchorHarmonyAnchorHarmonyAnchor
    | MotifHarmonyMotifAnchorHarmonyAnchor
    | MotifHarmonyMotifMotifHarmonyAnchor
    | MotifHarmonyMotifMotifHarmonyMotifHarmony
    | MotorHarmonyMotorMelodyMelodyHarmony
    | MotorHarmonyMotorAnchorHarmonyAnchor
    | MelodyMotorHarmonyMotorMotorHarmony


all : List Configuration
all =
    [ MelodyMotifMotorAnchor
    , MelodyMelodyHarmonyMotorAnchor
    , MelodyMelodyHarmonyMelodyHarmonyAnchor
    , MelodyMelodyHarmonyMelodyHarmonyMelodyHarmony
    , MelodyMotorHarmonyMotorAnchor
    , MelodyAnchorHarmonyAnchorHarmonyAnchor
    , MotifHarmonyMotifAnchorHarmonyAnchor
    , MotifHarmonyMotifMotifHarmonyAnchor
    , MotifHarmonyMotifMotifHarmonyMotifHarmony
    , MotorHarmonyMotorMelodyMelodyHarmony
    , MotorHarmonyMotorAnchorHarmonyAnchor
    , MelodyMotorHarmonyMotorMotorHarmony
    ]


render : List String -> List String
render =
    List.map2 Tuple.pair [ "L4", "L3", "L2", "L1" ] >> List.map (\( a, b ) -> a ++ " " ++ b)


toMultiLineString : Configuration -> List String
toMultiLineString onfiguration =
    case onfiguration of
        MelodyMotifMotorAnchor ->
            render [ "Melody", "Motif", "Motor", "Anchor" ]

        MelodyMelodyHarmonyMotorAnchor ->
            render [ "Melody", "MelodyHarmony", "Motor", "Anchor" ]

        MelodyMelodyHarmonyMelodyHarmonyAnchor ->
            render [ "Melody", "MelodyHarmony", "MelodyHarmony", "Anchor" ]

        MelodyMelodyHarmonyMelodyHarmonyMelodyHarmony ->
            render [ "Melody", "MelodyHarmony", "MelodyHarmony", "MelodyHarmony" ]

        MelodyMotorHarmonyMotorAnchor ->
            render [ "Melody", "MotorHarmony", "Motor", "Anchor" ]

        MelodyAnchorHarmonyAnchorHarmonyAnchor ->
            render [ "Melody", "AnchorHarmony", "AnchorHarmony", "Anchor" ]

        MotifHarmonyMotifAnchorHarmonyAnchor ->
            render [ "MotifHarmony", "Motif", "AnchorHarmony", "Anchor" ]

        MotifHarmonyMotifMotifHarmonyAnchor ->
            render [ "MotifHarmony", "Motif", "MotifHarmony", "Anchor" ]

        MotifHarmonyMotifMotifHarmonyMotifHarmony ->
            render [ "MotifHarmony", "Motif", "MotifHarmony", "MotifHarmony" ]

        MotorHarmonyMotorMelodyMelodyHarmony ->
            render [ "MotorHarmony", "Motor", "Melody", "MelodyHarmony" ]

        MotorHarmonyMotorAnchorHarmonyAnchor ->
            render [ "MotorHarmony", "Motor", "AnchorHarmony", "Anchor" ]

        MelodyMotorHarmonyMotorMotorHarmony ->
            render [ "Melody", "MotorHarmony", "Motor", "MotorHarmony" ]


random : Random.Generator Configuration
random =
    Random.uniform MelodyMotifMotorAnchor
        [ MelodyMelodyHarmonyMotorAnchor
        , MelodyMelodyHarmonyMelodyHarmonyAnchor
        , MelodyMelodyHarmonyMelodyHarmonyMelodyHarmony
        , MelodyMotorHarmonyMotorAnchor
        , MelodyAnchorHarmonyAnchorHarmonyAnchor
        , MotifHarmonyMotifAnchorHarmonyAnchor
        , MotifHarmonyMotifMotifHarmonyAnchor
        , MotifHarmonyMotifMotifHarmonyMotifHarmony
        , MotorHarmonyMotorMelodyMelodyHarmony
        , MotorHarmonyMotorAnchorHarmonyAnchor
        , MelodyMotorHarmonyMotorMotorHarmony
        ]
