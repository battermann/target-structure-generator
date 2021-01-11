module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import FirstPosition exposing (FirstPosition(..))
import FirstPositionDropdown
import Html
import Html.Attributes
import Html.Events
import MelodicForm exposing (MelodicForm(..))
import MelodicFormDropdown
import Metryx exposing (Metryx(..))
import MetryxDropdown
import Mode exposing (Mode(..))
import ModeDropdown
import Random
import Tempo exposing (Tempo)



---- MODEL ----


type alias Structure =
    { metryx : Metryx
    , tempo : Tempo
    , mode : Mode
    , firstPosition : FirstPosition
    , melodicForm : MelodicForm
    }


type alias Model =
    { metryx : MetryxDropdown.Model
    , tempo : Tempo
    , mode : ModeDropdown.Model
    , firstPosition : FirstPositionDropdown.Model
    , melodicForm : MelodicFormDropdown.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { metryx = MetryxDropdown.init Metryx_3_2
      , mode = ModeDropdown.init Ionian
      , firstPosition = FirstPositionDropdown.init Open
      , melodicForm = MelodicFormDropdown.init Period
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
    | Randomize
    | Generated Structure


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MetryxMsg metryxMsg ->
            ( { model
                | metryx = MetryxDropdown.update metryxMsg model.metryx
                , tempo = Tempo.tempo model.metryx.value (Tempo.bpm model.tempo)
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
                    ( { model | tempo = Tempo.tempo model.metryx.value tempo }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        Randomize ->
            ( model, Random.generate Generated random )

        Generated structure ->
            ( { model
                | metryx = MetryxDropdown.init structure.metryx
                , mode = ModeDropdown.init structure.mode
                , firstPosition = FirstPositionDropdown.init structure.firstPosition
                , melodicForm = MelodicFormDropdown.init structure.melodicForm
                , tempo = structure.tempo
              }
            , Cmd.none
            )


random : Random.Generator Structure
random =
    Random.map4
        (\( metryx, tempo ) mode firstPosition melodicForm ->
            { metryx = metryx
            , tempo = tempo
            , mode = mode
            , firstPosition = firstPosition
            , melodicForm = melodicForm
            }
        )
        (Metryx.random |> Random.andThen (\m -> Tempo.random m |> Random.map (Tuple.pair m)))
        Mode.random
        FirstPosition.random
        MelodicForm.random



---- VIEW ----


viewTempo : Model -> Html.Html Msg
viewTempo model =
    let
        ( min, max ) =
            Tempo.range model.metryx.value |> Tuple.mapBoth String.fromInt String.fromInt
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
    Html.div []
        [ Form.form []
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
        , Button.button
            [ Button.primary
            , Button.attrs
                [ Size.w100
                , Html.Attributes.style "max-width" "300px"
                ]
            , Button.onClick Randomize
            ]
            [ Html.div [] [ Html.i [ Html.Attributes.class "fas fa-random", Spacing.mr2 ] [], Html.text "RANDOMIZE" ] ]
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
