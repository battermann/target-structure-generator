module Models.Configuration exposing (Configuration(..), all, random, toMultiLineString)

import Random


type Configuration
    = MelodyMotifMotorAnchor
    | MelodyMelodyHarmonyMotorAnchor
    | MelodyMelodyHarmonyMelodyHarmonyAnchor
    | MelodyMelodyHarmonyMelodyHarmonyMelodyHarmony
    | MotifMotifHarmonyMotorAnchor
    | MotorMelodyMotifHarmonyMotif
    | MotifHarmonyMotifMelodyHarmonyMelody
    | MelodyMotorHarmonyMotorAnchor
    | MotorHarmonyMelodyMotorAnchor
    | MelodyMotorAnchorHarmonyAnchor
    | Motor_2Motor_1MelodyMelodyHarmony
    | MotifHarmonyMotifAnchorHarmonyAnchor
    | MotifHarmonyMotifMotifHarmonyAnchor
    | MotifHarmonyMotifMotifHarmonyMotifHarmony
    | MelodyMotor_2Motor_1Anchor
    | MotorHarmonyMotorAnchorHarmonyAnchor


all : List Configuration
all =
    [ MelodyMotifMotorAnchor
    , MelodyMelodyHarmonyMotorAnchor
    , MelodyMelodyHarmonyMelodyHarmonyAnchor
    , MelodyMelodyHarmonyMelodyHarmonyMelodyHarmony
    , MotifMotifHarmonyMotorAnchor
    , MotorMelodyMotifHarmonyMotif
    , MotifHarmonyMotifMelodyHarmonyMelody
    , MelodyMotorHarmonyMotorAnchor
    , MotorHarmonyMelodyMotorAnchor
    , MelodyMotorAnchorHarmonyAnchor
    , Motor_2Motor_1MelodyMelodyHarmony
    , MotifHarmonyMotifAnchorHarmonyAnchor
    , MotifHarmonyMotifMotifHarmonyAnchor
    , MotifHarmonyMotifMotifHarmonyMotifHarmony
    , MelodyMotor_2Motor_1Anchor
    , MotorHarmonyMotorAnchorHarmonyAnchor
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
            render [ "Melody", "Melody HARMONY", "Motor", "Anchor" ]

        MelodyMelodyHarmonyMelodyHarmonyAnchor ->
            render [ "Melody", "Melody HARMONY", "Melody HARMONY", "Anchor" ]

        MelodyMelodyHarmonyMelodyHarmonyMelodyHarmony ->
            render [ "Melody", "Melody HARMONY", "Melody HARMONY", "Melody HARMONY" ]

        MotifMotifHarmonyMotorAnchor ->
            render [ "Motif", "Motif HARMONY", "Motor", "Anchor" ]

        MotorMelodyMotifHarmonyMotif ->
            render [ "Motor", "Melody", "Motif HARMONY", "Motif" ]

        MotifHarmonyMotifMelodyHarmonyMelody ->
            render [ "Motif HARMONY", "Motif", "Melody HARMONY", "Melody" ]

        MelodyMotorHarmonyMotorAnchor ->
            render [ "Melody", "Motor HARMONY", "Motor", "Anchor" ]

        MotorHarmonyMelodyMotorAnchor ->
            render [ "Motor HARMONY", "Melody", "Motor", "Anchor" ]

        MelodyMotorAnchorHarmonyAnchor ->
            render [ "Melody", "Motor", "Anchor HARMONY", "Anchor" ]

        Motor_2Motor_1MelodyMelodyHarmony ->
            render [ "Motor 2", "Motor 1", "Melody", "Melody HARMONY" ]

        MotifHarmonyMotifAnchorHarmonyAnchor ->
            render [ "Motif HARMONY", "Motif", "Anchor HARMONY", "Anchor" ]

        MotifHarmonyMotifMotifHarmonyAnchor ->
            render [ "Motif HARMONY", "Motif", "Motif HARMONY", "Anchor" ]

        MotifHarmonyMotifMotifHarmonyMotifHarmony ->
            render [ "Motif HARMONY", "Motif", "Motif HARMONY", "Motif HARMONY" ]

        MelodyMotor_2Motor_1Anchor ->
            render [ "Melody", "Motor 2", "Motor 1", "Anchor" ]

        MotorHarmonyMotorAnchorHarmonyAnchor ->
            render [ "Motor HARMONY", "Motor", "Anchor HARMONY", "Anchor" ]


random : Random.Generator Configuration
random =
    Random.uniform MelodyMotifMotorAnchor
        [ MelodyMelodyHarmonyMotorAnchor
        , MelodyMelodyHarmonyMelodyHarmonyAnchor
        , MelodyMelodyHarmonyMelodyHarmonyMelodyHarmony
        , MotifMotifHarmonyMotorAnchor
        , MotorMelodyMotifHarmonyMotif
        , MotifHarmonyMotifMelodyHarmonyMelody
        , MelodyMotorHarmonyMotorAnchor
        , MotorHarmonyMelodyMotorAnchor
        , MelodyMotorAnchorHarmonyAnchor
        , Motor_2Motor_1MelodyMelodyHarmony
        , MotifHarmonyMotifAnchorHarmonyAnchor
        , MotifHarmonyMotifMotifHarmonyAnchor
        , MotifHarmonyMotifMotifHarmonyMotifHarmony
        , MelodyMotor_2Motor_1Anchor
        , MotorHarmonyMotorAnchorHarmonyAnchor
        ]
