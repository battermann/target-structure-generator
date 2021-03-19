module Main exposing (main)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Tab as Tab
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Browser
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
    , tabState : Tab.State
    }


init : ( Model, Cmd Msg )
init =
    Generator3D.init
        |> Tuple.mapBoth
            (\m ->
                { generator3D = m
                , tabState = Tab.initialState
                }
            )
            (Cmd.map Generator3DMsg)



---- UPDATE ----


type Msg
    = Generator3DMsg Generator3D.Msg
    | TabMsg Tab.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generator3DMsg subMsg ->
            Generator3D.update subMsg model.generator3D
                |> Tuple.mapBoth (\m -> { model | generator3D = m }) (Cmd.map Generator3DMsg)

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
                , link = Tab.link [] [ Html.text "3-D Generator" ]
                , pane =
                    Tab.pane [ Spacing.mt3 ]
                        [ Generator3D.view model.generator3D |> Html.map Generator3DMsg ]
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
        [ Generator3D.subscriptions model.generator3D |> Sub.map Generator3DMsg ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
