module Main exposing (..)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Browser
import Html
import Html.Attributes
import Html.Events
import Metryx exposing (Metryx(..))
import Mode exposing (Mode(..))



---- MODEL ----


type alias Model =
    { metryxState : Dropdown.State
    , metryx : Metryx
    }


init : ( Model, Cmd Msg )
init =
    ( { metryxState = Dropdown.initialState
      , metryx = Metryx_3_2
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = MetryxStateMsg Dropdown.State
    | MetryxMsg Metryx


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MetryxStateMsg state ->
            ( { model | metryxState = state }, Cmd.none )

        MetryxMsg metryx ->
            ( { model | metryx = metryx }, Cmd.none )



---- VIEW ----


viewDropdown : String -> (Dropdown.State -> Msg) -> Dropdown.State -> List ( Msg, String ) -> Html.Html Msg
viewDropdown name toggleMsg state items =
    Dropdown.dropdown
        state
        { options = [ Dropdown.attrs [ Size.w25 ], Dropdown.dropRight ]
        , toggleMsg = toggleMsg
        , toggleButton =
            Dropdown.toggle [ Button.outlinePrimary, Button.large ] [ Html.text name ]
        , items =
            items
                |> List.map
                    (\( msg, text ) ->
                        Dropdown.buttonItem [ Html.Events.onClick msg ] [ Html.text text ]
                    )
        }


view : Model -> Browser.Document Msg
view model =
    { title = "Target Structure Generator"
    , body =
        [ Grid.container []
            [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
            , Grid.row []
                [ Grid.col []
                    [ Html.h1 [] [ Html.text "Target Structure Generator" ]
                    , Html.div [ Spacing.mt5 ]
                        [ viewDropdown
                            ("Metryx " ++ Metryx.toString model.metryx)
                            MetryxStateMsg
                            model.metryxState
                            (Metryx.all |> List.map (\m -> ( MetryxMsg m, Metryx.toString m )))
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
        [ Dropdown.subscriptions model.metryxState MetryxStateMsg ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
