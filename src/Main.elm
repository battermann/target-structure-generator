module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Tab as Tab
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import ConfigurationGenerator
import FirstPosition exposing (FirstPosition(..))
import Generator3D
import Html
import Html.Attributes
import MelodicForm exposing (MelodicForm(..))
import Metryx exposing (Metryx(..))
import Mode exposing (Mode(..))



---- MODEL ----


type alias Model =
    { generator3D : Generator3D.Model
    , generatorConfig : ConfigurationGenerator.Model
    , tabState : Tab.State
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
      , tabState = Tab.initialState
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
    | TabMsg Tab.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generator3DMsg subMsg ->
            Generator3D.update subMsg model.generator3D
                |> Tuple.mapBoth (\m -> { model | generator3D = m }) (Cmd.map Generator3DMsg)

        GeneratorConfigMsg subMsg ->
            ConfigurationGenerator.update subMsg model.generatorConfig
                |> Tuple.mapBoth (\m -> { model | generatorConfig = m }) (Cmd.map GeneratorConfigMsg)

        TabMsg state ->
            ( { model | tabState = state }
            , Cmd.none
            )



---- VIEW ----


viewTabs : Model -> Html.Html Msg
viewTabs model =
    Tab.config TabMsg
        |> Tab.items
            [ Tab.item
                { id = "generator3d"
                , link = Tab.link [] [ Html.text "3-D Exercise Generator" ]
                , pane =
                    Tab.pane [ Spacing.mt3 ]
                        [ Generator3D.view model.generator3D |> Html.map Generator3DMsg ]
                }
            , Tab.item
                { id = "configurations-generator"
                , link = Tab.link [] [ Html.text "Configurations Generator" ]
                , pane =
                    Tab.pane [ Spacing.mt3 ]
                        [ ConfigurationGenerator.view model.generatorConfig |> Html.map GeneratorConfigMsg ]
                }
            ]
        |> Tab.view model.tabState


view : Model -> Browser.Document Msg
view model =
    { title = "Roger Treece Musical Fluency Exercise"
    , body =
        [ Grid.container []
            [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
            , Grid.row []
                [ Grid.col []
                    [ Html.h1 [ Spacing.mb3 ] [ Html.text "Roger Treece Musical Fluency Exercise" ]
                    , viewTabs model
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
