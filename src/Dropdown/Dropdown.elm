module Dropdown.Dropdown exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Dropdown as Dropdown
import Dropdown.View
import Html



---- MODEL ----


type alias Model a =
    { dropdownState : Dropdown.State
    , value : a
    }


init : a -> Model a
init value =
    { dropdownState = Dropdown.initialState
    , value = value
    }



---- UPDATE ----


type Msg a
    = DropdownStateMsg Dropdown.State
    | ModeMsg a


update : Msg a -> Model a -> Model a
update msg model =
    case msg of
        DropdownStateMsg state ->
            { model | dropdownState = state }

        ModeMsg value ->
            { model | value = value }



---- VIEW ----


view : Html.Html (Msg a) -> List a -> (a -> Html.Html (Msg a)) -> Model a -> Html.Html (Msg a)
view label all toHtml value =
    Dropdown.View.view
        label
        DropdownStateMsg
        value.dropdownState
        (all |> List.map (\m -> ( ModeMsg m, toHtml m )))



---- SUBSCRIPTION ----


subscriptions : Model a -> Sub (Msg a)
subscriptions value =
    Sub.batch
        [ Dropdown.subscriptions value.dropdownState DropdownStateMsg ]
