module FirstPositionDropdown exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Dropdown as Dropdown
import Dropdown
import FirstPosition exposing (FirstPosition(..))
import Html



---- MODEL ----


type alias Model =
    { dropdownState : Dropdown.State
    , value : FirstPosition
    }


init : FirstPosition -> Model
init value =
    { dropdownState = Dropdown.initialState
    , value = value
    }



---- UPDATE ----


type Msg
    = DropdownStateMsg Dropdown.State
    | FirstPositionMsg FirstPosition


update : Msg -> Model -> Model
update msg model =
    case msg of
        DropdownStateMsg state ->
            { model | dropdownState = state }

        FirstPositionMsg metryx ->
            { model | value = metryx }



---- VIEW ----


view : Model -> Html.Html Msg
view model =
    Dropdown.view
        ("First Position: " ++ FirstPosition.toString model.value)
        DropdownStateMsg
        model.dropdownState
        (FirstPosition.all |> List.map (\m -> ( FirstPositionMsg m, FirstPosition.toString m )))



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.dropdownState DropdownStateMsg ]
