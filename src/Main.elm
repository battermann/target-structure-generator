module Main exposing (main)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Flex as Flex
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import FirstPositionDropdown
import Html
import Html.Attributes
import MelodicFormDropdown
import Metryx exposing (Metryx(..))
import MetryxDropdown
import Mode exposing (Mode(..))
import ModeDropdown



---- MODEL ----


type alias Model =
    { metryx : MetryxDropdown.Model
    , mode : ModeDropdown.Model
    , firstPosition : FirstPositionDropdown.Model
    , melodicForm : MelodicFormDropdown.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { metryx = MetryxDropdown.init
      , mode = ModeDropdown.init
      , firstPosition = FirstPositionDropdown.init
      , melodicForm = MelodicFormDropdown.init
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = MetryxMsg MetryxDropdown.Msg
    | ModeMsg ModeDropdown.Msg
    | FirstPositionMsg FirstPositionDropdown.Msg
    | MelodicFormMsg MelodicFormDropdown.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MetryxMsg metryxMsg ->
            ( { model | metryx = MetryxDropdown.update metryxMsg model.metryx }, Cmd.none )

        ModeMsg modeMsg ->
            ( { model | mode = ModeDropdown.update modeMsg model.mode }, Cmd.none )

        FirstPositionMsg firstPositionMsg ->
            ( { model | firstPosition = FirstPositionDropdown.update firstPositionMsg model.firstPosition }, Cmd.none )

        MelodicFormMsg melodicFormMsg ->
            ( { model | melodicForm = MelodicFormDropdown.update melodicFormMsg model.melodicForm }, Cmd.none )



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
                        , Html.div [ Spacing.mt2 ] [ FirstPositionDropdown.view model.firstPosition |> Html.map FirstPositionMsg ]
                        , Html.div [ Spacing.mt2 ] [ MelodicFormDropdown.view model.melodicForm |> Html.map MelodicFormMsg ]
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
        , FirstPositionDropdown.subscriptions model.firstPosition |> Sub.map FirstPositionMsg
        , MelodicFormDropdown.subscriptions model.melodicForm |> Sub.map MelodicFormMsg
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
