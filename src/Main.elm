module Main exposing (main)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
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
    }


init : ( Model, Cmd Msg )
init =
    Generator3D.init
        |> Tuple.mapBoth (\m -> { generator3D = m }) (Cmd.map Generator3DMsg)



---- UPDATE ----


type Msg
    = Generator3DMsg Generator3D.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generator3DMsg subMsg ->
            Generator3D.update subMsg model.generator3D
                |> Tuple.mapBoth (\m -> { model | generator3D = m }) (Cmd.map Generator3DMsg)



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Target Structure Generator"
    , body =
        [ Grid.container []
            [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
            , Grid.row []
                [ Grid.col []
                    [ Html.h1 [] [ Html.text "Roger Treece Musical Fluency Exercise" ]
                    , Html.div [ Html.Attributes.class "text-muted" ] [ Html.text "Roger Treece Musical Fluency Exercise" ]
                    , Generator3D.view model.generator3D |> Html.map Generator3DMsg
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
