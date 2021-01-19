port module Ports exposing (startMetronome, stopMetronome)


port startMetronome : Int -> Cmd msg


port stopMetronome : () -> Cmd msg
