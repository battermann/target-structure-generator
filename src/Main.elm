module Main exposing (main)

import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import FirstPositionDropdown
import Html
import Html.Attributes
import Html.Events
import MelodicFormDropdown
import Metryx exposing (Metryx(..))
import MetryxDropdown
import Mode exposing (Mode(..))
import ModeDropdown
import Tempo exposing (Tempo)



---- MODEL ----


type alias Model =
    { metryx : MetryxDropdown.Model
    , mode : ModeDropdown.Model
    , firstPosition : FirstPositionDropdown.Model
    , melodicForm : MelodicFormDropdown.Model
    , tempo : Tempo
    }


init : ( Model, Cmd Msg )
init =
    ( { metryx = MetryxDropdown.init
      , mode = ModeDropdown.init
      , firstPosition = FirstPositionDropdown.init
      , melodicForm = MelodicFormDropdown.init
      , tempo = Tempo.tempo Metryx_3_2 100
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = MetryxMsg MetryxDropdown.Msg
    | ModeMsg ModeDropdown.Msg
    | FirstPositionMsg FirstPositionDropdown.Msg
    | MelodicFormMsg MelodicFormDropdown.Msg
    | TempoMsg String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MetryxMsg metryxMsg ->
            ( { model
                | metryx = MetryxDropdown.update metryxMsg model.metryx
                , tempo = Tempo.tempo model.metryx.metryx (Tempo.bpm model.tempo)
              }
            , Cmd.none
            )

        ModeMsg modeMsg ->
            ( { model | mode = ModeDropdown.update modeMsg model.mode }, Cmd.none )

        FirstPositionMsg firstPositionMsg ->
            ( { model | firstPosition = FirstPositionDropdown.update firstPositionMsg model.firstPosition }, Cmd.none )

        MelodicFormMsg melodicFormMsg ->
            ( { model | melodicForm = MelodicFormDropdown.update melodicFormMsg model.melodicForm }, Cmd.none )

        TempoMsg tempoStr ->
            case String.toInt tempoStr of
                Just tempo ->
                    ( { model | tempo = Tempo.tempo model.metryx.metryx tempo }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )



---- VIEW ----


viewTempo : Model -> Html.Html Msg
viewTempo model =
    let
        ( min, max ) =
            Tempo.range model.metryx.metryx |> Tuple.mapBoth String.fromInt String.fromInt
    in
    Form.group []
        [ Form.label [] [ Html.text ("Tempo (" ++ min ++ "-" ++ max ++ "bpm): " ++ String.fromInt (Tempo.bpm model.tempo)) ]
        , Html.div []
            [ Html.input
                [ Spacing.mt2
                , Size.w100
                , Html.Attributes.style "max-width" "300px"
                , Html.Attributes.type_ "range"
                , Html.Attributes.min min
                , Html.Attributes.max max
                , Html.Attributes.value <| String.fromInt <| Tempo.bpm model.tempo
                , Html.Events.onInput TempoMsg
                ]
                []
            ]
        ]


viewForm : Model -> Html.Html Msg
viewForm model =
    Form.form []
        [ Form.group []
            [ Html.div [ Spacing.mt2 ] [ MetryxDropdown.view model.metryx |> Html.map MetryxMsg ]
            ]
        , viewTempo model
        , Form.group []
            [ Html.div [ Spacing.mt2 ] [ ModeDropdown.view model.mode |> Html.map ModeMsg ]
            ]
        , Form.group []
            [ Html.div [ Spacing.mt2 ] [ FirstPositionDropdown.view model.firstPosition |> Html.map FirstPositionMsg ]
            ]
        , Form.group []
            [ Html.div [ Spacing.mt2 ] [ MelodicFormDropdown.view model.melodicForm |> Html.map MelodicFormMsg ]
            ]
        ]


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
                    , viewForm model
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
