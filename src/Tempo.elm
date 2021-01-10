module Tempo exposing (Tempo, bpm, range, tempo)

import Metryx exposing (Metryx(..))


type Tempo
    = Bpm Int


range : Metryx -> ( number, number )
range metryx =
    case metryx of
        Metryx_3_2 ->
            ( 50, 150 )

        Metryx_3_3 ->
            ( 50, 115 )

        Metryx_3_4 ->
            ( 50, 110 )

        Metryx_4_2 ->
            ( 50, 150 )

        Metryx_4_3 ->
            ( 50, 115 )

        Metryx_4_4 ->
            ( 50, 110 )

        Metryx_5_2 ->
            ( 50, 150 )

        Metryx_5_3 ->
            ( 50, 115 )

        Metryx_5_4 ->
            ( 50, 110 )

        Metryx_6_2 ->
            ( 50, 150 )

        Metryx_7_2 ->
            ( 50, 150 )


normalize : ( comparable, comparable ) -> comparable -> comparable
normalize ( min, max ) v =
    if v < min then
        min

    else if v > max then
        max

    else
        v


tempo : Metryx -> Int -> Tempo
tempo metryx v =
    Bpm <| normalize (range metryx) v


bpm : Tempo -> Int
bpm (Bpm v) =
    v
