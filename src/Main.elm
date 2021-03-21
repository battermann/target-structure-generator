module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import ConfigurationGenerator
import Generator3D
import Html
import Html.Attributes
import Html.Events



---- MODEL ----


type ActiveTab
    = Generator3DTab
    | GeneratorConfigTab


type alias Model =
    { generator3D : Generator3D.Model
    , generatorConfig : ConfigurationGenerator.Model
    , tabState : ActiveTab
    }


init : ( Model, Cmd Msg )
init =
    let
        ( gen3dModel, generator3dCmd ) =
            Generator3D.init

        ( generatorConfigModel, generatorConfigCmd ) =
            ConfigurationGenerator.init
    in
    ( { generator3D = gen3dModel
      , generatorConfig = generatorConfigModel
      , tabState = Generator3DTab
      }
    , Cmd.batch
        [ generator3dCmd |> Cmd.map Generator3DMsg
        , generatorConfigCmd |> Cmd.map GeneratorConfigMsg
        ]
    )



---- UPDATE ----


type Msg
    = Generator3DMsg Generator3D.Msg
    | GeneratorConfigMsg ConfigurationGenerator.Msg
    | TabChanged ActiveTab


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generator3DMsg subMsg ->
            Generator3D.update subMsg model.generator3D
                |> Tuple.mapBoth (\m -> { model | generator3D = m }) (Cmd.map Generator3DMsg)

        GeneratorConfigMsg subMsg ->
            ConfigurationGenerator.update subMsg model.generatorConfig
                |> Tuple.mapBoth (\m -> { model | generatorConfig = m }) (Cmd.map GeneratorConfigMsg)

        TabChanged tab ->
            ( { model | tabState = tab }
            , Cmd.none
            )



---- VIEW ----


viewButtonGroup : Model -> Html.Html Msg
viewButtonGroup model =
    ButtonGroup.radioButtonGroup [ ButtonGroup.attrs [ Spacing.mb3 ] ]
        [ ButtonGroup.radioButton
            (model.tabState == Generator3DTab)
            [ Button.light, Button.onClick <| TabChanged Generator3DTab ]
            [ Html.text "3-D Exercise Generator" ]
        , ButtonGroup.radioButton
            (model.tabState == GeneratorConfigTab)
            [ Button.light, Button.onClick <| TabChanged GeneratorConfigTab ]
            [ Html.text "Configuration Generator" ]
        ]


viewGenerators : Model -> Html.Html Msg
viewGenerators model =
    case model.tabState of
        Generator3DTab ->
            Generator3D.view model.generator3D |> Html.map Generator3DMsg

        GeneratorConfigTab ->
            ConfigurationGenerator.view model.generatorConfig |> Html.map GeneratorConfigMsg


view : Model -> Browser.Document Msg
view model =
    { title = "Roger Treece Musical Fluency Exercise"
    , body =
        [ Grid.container []
            [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
            , Grid.row []
                [ Grid.col []
                    [ Html.h1 [ Spacing.mb3 ] [ Html.text "Roger Treece Musical Fluency Exercise" ]
                    , viewButtonGroup model
                    , viewGenerators model
                    , Button.linkButton
                        [ Button.roleLink, Button.attrs [ Size.w100, Html.Attributes.style "max-width" "300px", Html.Attributes.href "https://github.com/battermann/target-structure-generator" ] ]
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
        [ Generator3D.subscriptions model.generator3D |> Sub.map Generator3DMsg
        , ConfigurationGenerator.subscriptions model.generatorConfig |> Sub.map GeneratorConfigMsg
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
