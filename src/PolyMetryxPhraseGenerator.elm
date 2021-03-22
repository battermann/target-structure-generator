module PolyMetryxPhraseGenerator exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Grid as Grid
import Bootstrap.Utilities.Size as Size
import Bootstrap.Utilities.Spacing as Spacing
import Dropdown.Dropdown as Dropdown
import Html
import Html.Attributes
import Markdown
import Models.MelodicForm as MelodicForm exposing (MelodicForm(..))
import Models.Metryx exposing (Metryx(..))
import Models.Mode as Mode exposing (Mode(..))
import Models.PolyMetryx as PolyMetryx exposing (PolyMetryx)
import Random



---- MODEL ----


type alias Structure =
    { mode : Mode
    , melodicForm : MelodicForm
    , polyMetryx : PolyMetryx
    }


type alias Model =
    { mode : Dropdown.Model Mode
    , melodicForm : Dropdown.Model MelodicForm
    , polyMetryx : Dropdown.Model PolyMetryx
    }


init : ( Model, Cmd Msg )
init =
    ( { mode = Dropdown.init Ionian
      , melodicForm = Dropdown.init Period
      , polyMetryx = Dropdown.init ( Metryx_3_2, Metryx_3_3 )
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ModeMsg (Dropdown.Msg Mode)
    | MelodicFormMsg (Dropdown.Msg MelodicForm)
    | PolyMetryxMsg (Dropdown.Msg PolyMetryx)
    | Randomize
    | Generated Structure


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ModeMsg subMsg ->
            ( { model | mode = Dropdown.update subMsg model.mode }, Cmd.none )

        MelodicFormMsg subMsg ->
            ( { model | melodicForm = Dropdown.update subMsg model.melodicForm }, Cmd.none )

        PolyMetryxMsg subMsg ->
            ( { model | polyMetryx = Dropdown.update subMsg model.polyMetryx }, Cmd.none )

        Randomize ->
            ( model, Random.generate Generated random )

        Generated structure ->
            ( { model
                | mode = Dropdown.init structure.mode
                , melodicForm = Dropdown.init structure.melodicForm
                , polyMetryx = Dropdown.init structure.polyMetryx
              }
            , Cmd.none
            )


random : Random.Generator Structure
random =
    Random.map3
        (\mode melodicForm polyMetryx ->
            { mode = mode
            , melodicForm = melodicForm
            , polyMetryx = polyMetryx
            }
        )
        Mode.random
        MelodicForm.random
        PolyMetryx.random



---- VIEW ----


viewPolyMetryx : PolyMetryx -> Html.Html msg
viewPolyMetryx polyMetryx =
    Html.div []
        (PolyMetryx.toMultiLineString polyMetryx
            |> List.map (\t -> Html.div [] [ Html.text t ])
            |> List.singleton
            |> List.map (Html.p [])
        )


description : String
description =
    """### Poly-Metryx Exercise

The value of this exercise is to create different patterns for measure-by-measure rhythmic combustion by super-imposing one *Metryx* over another.

The *alternate combustion* is usually found in the shorter phrase lengths.

A value of the alternate combustion in larger phrases is that you’ve got *more longevity built into the pattern*. What this becomes is a texture of Sub-Division, rather than a measure-by-measure phrase combustion.

This will create various phrase-length possibilities, which will create various *Couplet* patterns within the phrases.

This will also de-sensitize one’s self to the grouping of the Sub-Div in the first *Metryx*.

In this exercise, the sub-division remains constant. One voice will be the Motor and the second, the Anchor. The two different numbers after each *Metryx* are the number of measures required for the two different *Metryx* to come together on a downbeat on 1.

**Guidelines**:

1. Use only *Metryx* patterns.

2. Choose one *Metryx* as the *Motor Metryx* and the other as the *Anchor Metryx*.

3. The *Anchor Metryx* is going to be the ruling *Metryx*,  the actual *Metryx*. It will determine the length of your phrase and the *Couplet movement*.

4. The Motor will be static; only the Anchor will move.

```txt
    Example: 3-4 = 5
             5-3 = 4
```

If you choose 3-4 as your *Motor Metryx*, you’ll actually be in a 5-3 *Metryx*, and your phrase will be four measures long.

If you choose 5-3 as you *Motor Metryx*, you’ll actually be in a 3-4 *Metryx*, and you’ll have a five-measure phrase.
"""


viewDescription : Html.Html Msg
viewDescription =
    Markdown.toHtml [] description


viewGenerator : Model -> Html.Html Msg
viewGenerator model =
    Html.div []
        [ Form.group []
            [ Html.div [ Spacing.mt2 ]
                [ Dropdown.view
                    (Html.div [] [ Html.text "PolyMetryx:", viewPolyMetryx model.polyMetryx.value ])
                    PolyMetryx.all
                    viewPolyMetryx
                    model.polyMetryx
                    |> Html.map PolyMetryxMsg
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
            , Button.attrs [ Size.w100, Html.Attributes.style "max-width" "360px", Spacing.mr2 ]
            ]
            [ Html.div [] [ Html.i [ Html.Attributes.class "fas fa-random", Spacing.mr2 ] [], Html.text "RANDOMIZE" ] ]
        ]


view : Model -> Html.Html Msg
view model =
    Grid.container []
        [ Grid.row []
            [ Grid.col [] [ viewGenerator model ]
            , Grid.col [] [ viewDescription ]
            ]
        ]



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.mode |> Sub.map ModeMsg
        , Dropdown.subscriptions model.melodicForm |> Sub.map MelodicFormMsg
        , Dropdown.subscriptions model.polyMetryx |> Sub.map PolyMetryxMsg
        ]
