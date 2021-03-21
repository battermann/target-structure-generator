module PolymetricPhraseGenerator exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Dropdown.Dropdown as Dropdown
import Html
import Html.Attributes
import Models.MelodicFormPlus as MelodicForm exposing (MelodicForm(..))
import Models.Metryx exposing (Metryx(..))
import Models.Mode as Mode exposing (Mode(..))
import Models.Polymetric as Polymetric exposing (Polymetric)
import Random



---- MODEL ----


type alias Structure =
    { mode : Mode
    , melodicForm : MelodicForm
    , polymetric : Polymetric
    }


type alias Model =
    { mode : Dropdown.Model Mode
    , melodicForm : Dropdown.Model MelodicForm
    , polymetric : Dropdown.Model Polymetric
    }


init : ( Model, Cmd Msg )
init =
    ( { mode = Dropdown.init Ionian
      , melodicForm = Dropdown.init Period
      , polymetric = Dropdown.init ( Metryx_3_2, Metryx_3_3 )
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ModeMsg (Dropdown.Msg Mode)
    | MelodicFormMsg (Dropdown.Msg MelodicForm)
    | PolymetricMsg (Dropdown.Msg Polymetric)
    | Randomize
    | Generated Structure


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ModeMsg subMsg ->
            ( { model | mode = Dropdown.update subMsg model.mode }, Cmd.none )

        MelodicFormMsg subMsg ->
            ( { model | melodicForm = Dropdown.update subMsg model.melodicForm }, Cmd.none )

        PolymetricMsg subMsg ->
            ( { model | polymetric = Dropdown.update subMsg model.polymetric }, Cmd.none )

        Randomize ->
            ( model, Random.generate Generated random )

        Generated structure ->
            ( { model
                | mode = Dropdown.init structure.mode
                , melodicForm = Dropdown.init structure.melodicForm
                , polymetric = Dropdown.init structure.polymetric
              }
            , Cmd.none
            )


random : Random.Generator Structure
random =
    Random.map3
        (\mode melodicForm polymetric ->
            { mode = mode
            , melodicForm = melodicForm
            , polymetric = polymetric
            }
        )
        Mode.random
        MelodicForm.random
        Polymetric.random



---- VIEW ----


viewPolymetric : Polymetric -> Html.Html msg
viewPolymetric polymetric =
    Html.div []
        (Polymetric.toMultiLineString polymetric
            |> List.map (\t -> Html.div [] [ Html.text t ])
            |> List.singleton
            |> List.map (Html.p [])
        )


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Form.group []
            [ Html.div [ Spacing.mt2 ]
                [ Dropdown.view
                    (Html.div [] [ Html.text "Polymetric:", viewPolymetric model.polymetric.value ])
                    Polymetric.all
                    viewPolymetric
                    model.polymetric
                    |> Html.map PolymetricMsg
                ]
            ]
        , Form.form []
            [ Form.group []
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view (Html.text ("Mode: " ++ Mode.toString model.mode.value)) Mode.all (Mode.toString >> Html.text) model.mode |> Html.map ModeMsg ]
                ]
            ]
        , Form.form []
            [ Form.group []
                [ Html.div [ Spacing.mt2 ] [ Dropdown.view (Html.text ("Melodic Form: " ++ MelodicForm.toString model.melodicForm.value)) MelodicForm.all (MelodicForm.toString >> Html.text) model.melodicForm |> Html.map MelodicFormMsg ]
                ]
            ]
        , Button.button
            [ Button.primary
            , Button.large
            , Button.onClick Randomize
            , Button.attrs [ Size.w100, Html.Attributes.style "max-width" "300px", Spacing.mr2 ]
            ]
            [ Html.div [] [ Html.i [ Html.Attributes.class "fas fa-random", Spacing.mr2 ] [], Html.text "RANDOMIZE" ] ]
        ]



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.mode |> Sub.map ModeMsg
        , Dropdown.subscriptions model.melodicForm |> Sub.map MelodicFormMsg
        , Dropdown.subscriptions model.polymetric |> Sub.map PolymetricMsg
        ]
