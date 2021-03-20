module ConfigurationGenerator exposing (Model, Msg, init, subscriptions, update, view)

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
    , coupletPhrase : CoupletPhrase
    }


type Click
    = Play
    | Pause


type alias Model =
    { metryx : Dropdown.Model Metryx
    , tempo : Tempo
    , mode : Dropdown.Model Mode
    , coupletPhrase : Dropdown.Model CoupletPhrase
    , click : Click
    }


init : ( Model, Cmd Msg )
init =
    ( { metryx = Dropdown.init Metryx_3_2
      , mode = Dropdown.init Ionian
      , coupletPhrase = Dropdown.init AB
      , tempo = Tempo.tempo Metryx_3_2 100
      , click = Pause
      }
    , Cmd.batch [ Metryx_3_2 |> Metryx.beats |> Ports.setBeats, 100 |> Tempo.tempo Metryx_3_2 |> Tempo.bpm |> Ports.setBpm ]
    )



---- UPDATE ----


type Msg
    = MetryxMsg (Dropdown.Msg Metryx)
    | ModeMsg (Dropdown.Msg Mode)
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
    Random.map3
        (\( metryx, tempo ) mode coupletPhrase ->
            { metryx = metryx
            , tempo = tempo
            , mode = mode
            , coupletPhrase = coupletPhrase
            }
        )
        (Metryx.random |> Random.andThen (\m -> Tempo.random m |> Random.map (Tuple.pair m)))
        Mode.random
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
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view "Metryx" Metryx.all Metryx.toString model.metryx |> Html.map MetryxMsg ]
                ]
            , viewTempo model
            , Form.group []
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view "Mode" Mode.all Mode.toString model.mode |> Html.map ModeMsg ]
                ]
            , Form.group []
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view "Couplet Phrase" CoupletPhrase.all CoupletPhrase.toString model.coupletPhrase |> Html.map CoupletPhraseMsg ]
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
        ]



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.metryx |> Sub.map MetryxMsg
        , Dropdown.subscriptions model.mode |> Sub.map ModeMsg
        , Dropdown.subscriptions model.coupletPhrase |> Sub.map CoupletPhraseMsg
        ]
