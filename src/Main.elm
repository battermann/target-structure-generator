module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import ConfigurationGenerator
import Html
import Html.Attributes
import PolyMetryxPhraseGenerator
import Ports
import ThreeDExerciseGenerator



---- MODEL ----


type ActiveTab
    = ThreeDExerciseGeneratorTab
    | ConfigurationGeneratorTab
    | PolyMetryxPhraseGeneratorTab


type alias Model =
    { threeDExerciseGenerator : ThreeDExerciseGenerator.Model
    , configurationGenerator : ConfigurationGenerator.Model
    , polyMetryxPhraseGenerator : PolyMetryxPhraseGenerator.Model
    , tabState : ActiveTab
    }


init : ( Model, Cmd Msg )
init =
    let
        ( threeDExerciseGeneratorModel, threeDExerciseGeneratorCmd ) =
            ThreeDExerciseGenerator.init

        configurationGeneratorModel =
            ConfigurationGenerator.init |> Tuple.first

        generatorPolyMetryxPhraseModel =
            PolyMetryxPhraseGenerator.init |> Tuple.first
    in
    ( { threeDExerciseGenerator = threeDExerciseGeneratorModel
      , configurationGenerator = configurationGeneratorModel
      , polyMetryxPhraseGenerator = generatorPolyMetryxPhraseModel
      , tabState = ThreeDExerciseGeneratorTab
      }
    , Cmd.batch
        [ threeDExerciseGeneratorCmd |> Cmd.map ThreeDExerciseGeneratorMsg
        ]
    )


initTab : Model -> ( Model, Cmd Msg )
initTab model =
    case model.tabState of
        ThreeDExerciseGeneratorTab ->
            ThreeDExerciseGenerator.resetClick model.threeDExerciseGenerator |> Tuple.mapBoth (\m -> { model | threeDExerciseGenerator = m }) (Cmd.map ThreeDExerciseGeneratorMsg)

        ConfigurationGeneratorTab ->
            ConfigurationGenerator.resetClick model.configurationGenerator |> Tuple.mapBoth (\m -> { model | configurationGenerator = m }) (Cmd.map ConfigurationGeneratorMsg)

        PolyMetryxPhraseGeneratorTab ->
            ( model, Ports.stopMetronome () )



---- UPDATE ----


type Msg
    = ThreeDExerciseGeneratorMsg ThreeDExerciseGenerator.Msg
    | ConfigurationGeneratorMsg ConfigurationGenerator.Msg
    | TabChanged ActiveTab
    | PolyMetryxPhraseGeneratorMsg PolyMetryxPhraseGenerator.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ThreeDExerciseGeneratorMsg subMsg ->
            ThreeDExerciseGenerator.update subMsg model.threeDExerciseGenerator
                |> Tuple.mapBoth (\m -> { model | threeDExerciseGenerator = m }) (Cmd.map ThreeDExerciseGeneratorMsg)

        ConfigurationGeneratorMsg subMsg ->
            ConfigurationGenerator.update subMsg model.configurationGenerator
                |> Tuple.mapBoth (\m -> { model | configurationGenerator = m }) (Cmd.map ConfigurationGeneratorMsg)

        TabChanged tab ->
            initTab { model | tabState = tab }

        PolyMetryxPhraseGeneratorMsg subMsg ->
            PolyMetryxPhraseGenerator.update subMsg model.polyMetryxPhraseGenerator
                |> Tuple.mapBoth (\m -> { model | polyMetryxPhraseGenerator = m }) (Cmd.map PolyMetryxPhraseGeneratorMsg)



---- VIEW ----


viewButtonGroup : Model -> Html.Html Msg
viewButtonGroup model =
    ButtonGroup.radioButtonGroup [ ButtonGroup.attrs [ Spacing.mb3, Size.w100 ] ]
        [ ButtonGroup.radioButton
            (model.tabState == ThreeDExerciseGeneratorTab)
            [ Button.light, Button.onClick <| TabChanged ThreeDExerciseGeneratorTab ]
            [ Html.text "3-D Exercise Generator" ]
        , ButtonGroup.radioButton
            (model.tabState == ConfigurationGeneratorTab)
            [ Button.light, Button.onClick <| TabChanged ConfigurationGeneratorTab ]
            [ Html.text "Configuration Generator" ]
        , ButtonGroup.radioButton
            (model.tabState == PolyMetryxPhraseGeneratorTab)
            [ Button.light, Button.onClick <| TabChanged PolyMetryxPhraseGeneratorTab ]
            [ Html.text "PolyMetryx Phrase Generator" ]
        ]


viewGenerators : Model -> Html.Html Msg
viewGenerators model =
    case model.tabState of
        ThreeDExerciseGeneratorTab ->
            ThreeDExerciseGenerator.view model.threeDExerciseGenerator |> Html.map ThreeDExerciseGeneratorMsg

        ConfigurationGeneratorTab ->
            ConfigurationGenerator.view model.configurationGenerator |> Html.map ConfigurationGeneratorMsg

        PolyMetryxPhraseGeneratorTab ->
            PolyMetryxPhraseGenerator.view model.polyMetryxPhraseGenerator |> Html.map PolyMetryxPhraseGeneratorMsg


view : Model -> Browser.Document Msg
view model =
    { title = "Roger Treece Musical Fluency Exercises"
    , body =
        [ Grid.container []
            [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
            , Grid.row []
                [ Grid.col []
                    [ Html.h1 [ Spacing.mb3 ] [ Html.text "Roger Treece Musical Fluency Exercises" ]
                    , viewButtonGroup model
                    , viewGenerators model
                    , Button.linkButton
                        [ Button.roleLink, Button.attrs [ Size.w100, Html.Attributes.style "max-width" "360px", Html.Attributes.href "https://github.com/battermann/target-structure-generator" ] ]
                        [ Html.i [ Html.Attributes.class "fab fa-github" ] [], Html.text " Source Code" ]
                    ]
                ]
            ]
        ]
    }



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ ThreeDExerciseGenerator.subscriptions model.threeDExerciseGenerator |> Sub.map ThreeDExerciseGeneratorMsg
        , ConfigurationGenerator.subscriptions model.configurationGenerator |> Sub.map ConfigurationGeneratorMsg
        , PolyMetryxPhraseGenerator.subscriptions model.polyMetryxPhraseGenerator |> Sub.map PolyMetryxPhraseGeneratorMsg
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
