module MelodicFormDropdown exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Dropdown as Dropdown
import Dropdown
import Html
import MelodicForm exposing (MelodicForm(..))



---- MODEL ----


type alias Model =
    { dropdownState : Dropdown.State
    , melodicForm : MelodicForm
    }


init : Model
init =
    { dropdownState = Dropdown.initialState
    , melodicForm = Period
    }



---- UPDATE ----


type Msg
    = DropdownStateMsg Dropdown.State
    | MelodicFormMsg MelodicForm


update : Msg -> Model -> Model
update msg model =
    case msg of
        DropdownStateMsg state ->
            { model | dropdownState = state }

        MelodicFormMsg metryx ->
            { model | melodicForm = metryx }



---- VIEW ----


view : Model -> Html.Html Msg
view model =
    Dropdown.view
        ("Melodic Form: " ++ MelodicForm.toString model.melodicForm)
        DropdownStateMsg
        model.dropdownState
        (MelodicForm.all |> List.map (\m -> ( MelodicFormMsg m, MelodicForm.toString m )))



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.dropdownState DropdownStateMsg ]
