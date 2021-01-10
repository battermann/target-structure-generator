module FirstPosition exposing (FirstPosition(..), all, toString)


type FirstPosition
    = Open
    | Closed


all : List FirstPosition
all =
    [ Open, Closed ]


toString : FirstPosition -> String
toString firstPosition =
    case firstPosition of
        Open ->
            "Open"

        Closed ->
            "Closed"
