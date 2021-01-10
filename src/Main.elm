module Main exposing (main)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Flex as Flex
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import Html
import Html.Attributes
import Metryx exposing (Metryx(..))
import MetryxDropdown
import Mode exposing (Mode(..))
import ModeDropdown



---- MODEL ----


type alias Model =
    { metryx : MetryxDropdown.Model
    , mode : ModeDropdown.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { metryx = MetryxDropdown.init
      , mode = ModeDropdown.init
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = MetryxMsg MetryxDropdown.Msg
    | ModeMsg ModeDropdown.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MetryxMsg metryxMsg ->
            ( { model | metryx = MetryxDropdown.update metryxMsg model.metryx }, Cmd.none )

        ModeMsg modeMsg ->
            ( { model | mode = ModeDropdown.update modeMsg model.mode }, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Target Structure Generator"
    , body =
        [ Grid.container []
            [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
            , Grid.row []
                [ Grid.col []
                    [ Html.h1 [] [ Html.text "Target Structure Generator" ]
                    , Html.div [ Html.Attributes.class "text-muted" ] [ Html.text "Roger Treece Musical Fluency Exercise" ]
                    , Html.div [ Flex.block, Flex.col ]
                        [ Html.div [ Spacing.mt2 ] [ MetryxDropdown.view model.metryx |> Html.map MetryxMsg ]
                        , Html.div [ Spacing.mt2 ] [ ModeDropdown.view model.mode |> Html.map ModeMsg ]
                        ]
                    ]
                ]
            ]
        ]
    }



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ MetryxDropdown.subscriptions model.metryx |> Sub.map MetryxMsg
        , ModeDropdown.subscriptions model.mode |> Sub.map ModeMsg
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
