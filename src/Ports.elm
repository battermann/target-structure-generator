port module Ports exposing (setBeats, setBpm, startMetronome, stopMetronome)


port startMetronome : () -> Cmd msg


port stopMetronome : () -> Cmd msg


port setBpm : Int -> Cmd msg


port setBeats : Int -> Cmd msg
