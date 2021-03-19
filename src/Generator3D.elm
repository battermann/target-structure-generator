module Generator3D exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Utilities.Flex as Flex
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
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
import Ports
import Random
import Tempo exposing (Tempo, tempo)



---- MODEL ----


type alias Structure =
    { metryx : Metryx
    , tempo : Tempo
    , mode : Mode
    , firstPosition : FirstPosition
    , melodicForm : MelodicForm
    }


type Click
    = Play
    | Pause


type alias Model =
    { metryx : MetryxDropdown.Model
    , tempo : Tempo
    , mode : ModeDropdown.Model
    , firstPosition : FirstPositionDropdown.Model
    , melodicForm : MelodicFormDropdown.Model
    , click : Click
    }


init : ( Model, Cmd Msg )
init =
    ( { metryx = MetryxDropdown.init Metryx_3_2
      , mode = ModeDropdown.init Ionian
      , firstPosition = FirstPositionDropdown.init Open
      , melodicForm = MelodicFormDropdown.init Period
      , tempo = Tempo.tempo Metryx_3_2 100
      , click = Pause
      }
    , Cmd.batch [ Metryx_3_2 |> Metryx.beats |> Ports.setBeats, 100 |> Tempo.tempo Metryx_3_2 |> Tempo.bpm |> Ports.setBpm ]
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
    | ToggleClick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MetryxMsg metryxMsg ->
            let
                metryx =
                    MetryxDropdown.update metryxMsg model.metryx

                tempo =
                    Tempo.tempo model.metryx.value (Tempo.bpm model.tempo)
            in
            ( { model
                | metryx = metryx
                , tempo = tempo
              }
            , Cmd.batch [ metryx.value |> Metryx.beats |> Ports.setBeats, tempo |> Tempo.bpm |> Ports.setBpm ]
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
                    ( { model | tempo = Tempo.tempo model.metryx.value tempo }, tempo |> Tempo.tempo model.metryx.value |> Tempo.bpm |> Ports.setBpm )

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
            , Cmd.batch [ structure.metryx |> Metryx.beats |> Ports.setBeats, structure.tempo |> Tempo.bpm |> Ports.setBpm ]
            )

        ToggleClick ->
            case model.click of
                Pause ->
                    ( { model | click = Play }, Ports.startMetronome () )

                Play ->
                    ( { model | click = Pause }, Ports.stopMetronome () )


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


viewClickButtonIcon : Click -> Html.Attribute msg
viewClickButtonIcon click =
    case click of
        Pause ->
            Html.Attributes.class "fas fa-play"

        Play ->
            Html.Attributes.class "fas fa-stop"


view : Model -> Html.Html Msg
view model =
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
        , Html.div
            [ Size.w100
            , Html.Attributes.style "max-width" "300px"
            , Flex.block
            , Flex.row
            , Flex.justifyBetween
            ]
            [ Button.button
                [ Button.primary
                , Button.onClick Randomize
                , Button.attrs [ Size.w100, Spacing.mr2 ]
                ]
                [ Html.div [] [ Html.i [ Html.Attributes.class "fas fa-random", Spacing.mr2 ] [], Html.text "RANDOMIZE" ] ]
            , Button.button
                [ Button.success
                , Button.onClick ToggleClick
                , Button.attrs [ Html.Attributes.style "min-width" "100px" ]
                ]
                [ Html.div [] [ Html.i [ viewClickButtonIcon model.click, Spacing.mr2 ] [], Html.text "CLICK" ] ]
            ]
        , Button.linkButton
            [ Button.roleLink, Button.attrs [ Size.w100, Html.Attributes.style "max-width" "300px", Html.Attributes.href "https://github.com/battermann/target-structure-generator" ] ]
            [ Html.i [ Html.Attributes.class "fab fa-github" ] [], Html.text " Source Code" ]
        ]



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ MetryxDropdown.subscriptions model.metryx |> Sub.map MetryxMsg
        , ModeDropdown.subscriptions model.mode |> Sub.map ModeMsg
        , FirstPositionDropdown.subscriptions model.firstPosition |> Sub.map FirstPositionMsg
        , MelodicFormDropdown.subscriptions model.melodicForm |> Sub.map MelodicFormMsg
        ]
