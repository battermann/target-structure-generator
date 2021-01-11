module ModeDropdown exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Dropdown as Dropdown
import Dropdown
import Html
import Mode exposing (Mode(..))



---- MODEL ----


type alias Model =
    { dropdownState : Dropdown.State
    , mode : Mode
    }


init : Mode -> Model
init mode =
    { dropdownState = Dropdown.initialState
    , mode = mode
    }



---- UPDATE ----


type Msg
    = DropdownStateMsg Dropdown.State
    | ModeMsg Mode


update : Msg -> Model -> Model
update msg model =
    case msg of
        DropdownStateMsg state ->
            { model | dropdownState = state }

        ModeMsg metryx ->
            { model | mode = metryx }



---- VIEW ----


view : Model -> Html.Html Msg
view model =
    Dropdown.view
        ("Mode: " ++ Mode.toString model.mode)
        DropdownStateMsg
        model.dropdownState
        (Mode.all |> List.map (\m -> ( ModeMsg m, Mode.toString m )))



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.dropdownState DropdownStateMsg ]
