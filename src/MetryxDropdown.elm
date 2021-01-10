module MetryxDropdown exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Dropdown as Dropdown
import Dropdown
import Html
import Metryx exposing (Metryx(..))
import Mode exposing (Mode(..))



---- MODEL ----


type alias Model =
    { dropdownState : Dropdown.State
    , metryx : Metryx
    }


init : Model
init =
    { dropdownState = Dropdown.initialState
    , metryx = Metryx_3_2
    }



---- UPDATE ----


type Msg
    = DropdownStateMsg Dropdown.State
    | MetryxMsg Metryx


update : Msg -> Model -> Model
update msg model =
    case msg of
        DropdownStateMsg state ->
            { model | dropdownState = state }

        MetryxMsg metryx ->
            { model | metryx = metryx }



---- VIEW ----


view : Model -> Html.Html Msg
view model =
    Dropdown.view
        ("Metryx " ++ Metryx.toString model.metryx)
        DropdownStateMsg
        model.dropdownState
        (Metryx.all |> List.map (\m -> ( MetryxMsg m, Metryx.toString m )))



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.dropdownState DropdownStateMsg ]
