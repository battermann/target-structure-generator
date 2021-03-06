module ThreeDExerciseGenerator exposing (Model, Msg, init, resetClick, subscriptions, update, view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Utilities.Flex as Flex
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Dropdown.Dropdown as Dropdown
import Html
import Html.Attributes
import Html.Events
import Models.CoupletPhrase as CoupletPhrase exposing (CoupletPhrase(..))
import Models.FirstPosition as FirstPosition exposing (FirstPosition(..))
import Models.MelodicForm as MelodicForm exposing (MelodicForm(..))
import Models.Metryx as Metryx exposing (Metryx(..))
import Models.Mode as Mode exposing (Mode(..))
import Models.Tempo as Tempo exposing (Tempo, tempo)
import Ports
import Random



---- MODEL ----


type alias Structure =
    { metryx : Metryx
    , tempo : Tempo
    , mode : Mode
    , firstPosition : FirstPosition
    , melodicForm : MelodicForm
    , coupletPhrase : CoupletPhrase
    }


type Click
    = Play
    | Pause


type alias Model =
    { metryx : Dropdown.Model Metryx
    , tempo : Tempo
    , mode : Dropdown.Model Mode
    , firstPosition : Dropdown.Model FirstPosition
    , melodicForm : Dropdown.Model MelodicForm
    , coupletPhrase : Dropdown.Model CoupletPhrase
    , click : Click
    }


init : ( Model, Cmd Msg )
init =
    ( { metryx = Dropdown.init Metryx_3_2
      , mode = Dropdown.init Ionian
      , firstPosition = Dropdown.init Open
      , melodicForm = Dropdown.init Period
      , tempo = Tempo.tempo Metryx_3_2 100
      , coupletPhrase = Dropdown.init AB
      , click = Pause
      }
    , Cmd.batch
        [ Ports.stopMetronome ()
        , Metryx_3_2 |> Metryx.beats |> Ports.setBeats
        , 100 |> Tempo.tempo Metryx_3_2 |> Tempo.bpm |> Ports.setBpm
        ]
    )


resetClick : Model -> ( Model, Cmd Msg )
resetClick model =
    ( { model | click = Pause }
    , Cmd.batch
        [ Ports.stopMetronome ()
        , model.metryx.value |> Metryx.beats |> Ports.setBeats
        , model.tempo |> Tempo.bpm |> Ports.setBpm
        ]
    )



---- UPDATE ----


type Msg
    = MetryxMsg (Dropdown.Msg Metryx)
    | ModeMsg (Dropdown.Msg Mode)
    | FirstPositionMsg (Dropdown.Msg FirstPosition)
    | MelodicFormMsg (Dropdown.Msg MelodicForm)
    | CoupletPhraseMsg (Dropdown.Msg CoupletPhrase)
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
                    Dropdown.update metryxMsg model.metryx

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
            ( { model | mode = Dropdown.update modeMsg model.mode }, Cmd.none )

        FirstPositionMsg firstPositionMsg ->
            ( { model | firstPosition = Dropdown.update firstPositionMsg model.firstPosition }, Cmd.none )

        MelodicFormMsg melodicFormMsg ->
            ( { model | melodicForm = Dropdown.update melodicFormMsg model.melodicForm }, Cmd.none )

        CoupletPhraseMsg coupletPhraseMsg ->
            ( { model | coupletPhrase = Dropdown.update coupletPhraseMsg model.coupletPhrase }, Cmd.none )

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
                | metryx = Dropdown.init structure.metryx
                , mode = Dropdown.init structure.mode
                , firstPosition = Dropdown.init structure.firstPosition
                , melodicForm = Dropdown.init structure.melodicForm
                , tempo = structure.tempo
                , coupletPhrase = Dropdown.init structure.coupletPhrase
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
    Random.map5
        (\( metryx, tempo ) mode firstPosition melodicForm coupletPhrase ->
            { metryx = metryx
            , tempo = tempo
            , mode = mode
            , firstPosition = firstPosition
            , melodicForm = melodicForm
            , coupletPhrase = coupletPhrase
            }
        )
        (Metryx.random |> Random.andThen (\m -> Tempo.random m |> Random.map (Tuple.pair m)))
        Mode.random
        FirstPosition.random
        MelodicForm.random
        CoupletPhrase.random



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
                , Html.Attributes.style "max-width" "360px"
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
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view (Html.text ("Metryx: " ++ Metryx.toString model.metryx.value)) Metryx.all (Metryx.toString >> Html.text) model.metryx |> Html.map MetryxMsg ]
                ]
            , viewTempo model
            , Form.group []
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view (Html.text ("Mode: " ++ Mode.toString model.mode.value)) Mode.all (Mode.toString >> Html.text) model.mode |> Html.map ModeMsg ]
                ]
            , Form.group []
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view (Html.text ("First Position: " ++ FirstPosition.toString model.firstPosition.value)) FirstPosition.all (FirstPosition.toString >> Html.text) model.firstPosition |> Html.map FirstPositionMsg ]
                ]
            , Form.group []
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view (Html.text ("Melodic Form: " ++ MelodicForm.toString model.melodicForm.value)) MelodicForm.all (MelodicForm.toString >> Html.text) model.melodicForm |> Html.map MelodicFormMsg ]
                ]
            , Form.group []
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view (Html.text ("Couplet Phrase: " ++ CoupletPhrase.toString model.coupletPhrase.value)) CoupletPhrase.all (CoupletPhrase.toString >> Html.text) model.coupletPhrase |> Html.map CoupletPhraseMsg ]
                ]
            ]
        , Html.div
            [ Size.w100
            , Html.Attributes.style "max-width" "360px"
            , Flex.block
            , Flex.row
            , Flex.justifyBetween
            ]
            [ Button.button
                [ Button.primary
                , Button.large
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
        ]



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.metryx |> Sub.map MetryxMsg
        , Dropdown.subscriptions model.mode |> Sub.map ModeMsg
        , Dropdown.subscriptions model.firstPosition |> Sub.map FirstPositionMsg
        , Dropdown.subscriptions model.melodicForm |> Sub.map MelodicFormMsg
        , Dropdown.subscriptions model.coupletPhrase |> Sub.map CoupletPhraseMsg
        ]
