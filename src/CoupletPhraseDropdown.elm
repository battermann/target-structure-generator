module CoupletPhraseDropdown exposing (Model, Msg, init, subscriptions, update, view)

import Bootstrap.Dropdown as Dropdown
import CoupletPhrase exposing (CoupletPhrase(..))
import Dropdown
import Html



---- MODEL ----


type alias Model =
    { dropdownState : Dropdown.State
    , coupletPhrase : CoupletPhrase
    }


init : CoupletPhrase -> Model
init coupletPhrase =
    { dropdownState = Dropdown.initialState
    , coupletPhrase = coupletPhrase
    }



---- UPDATE ----


type Msg
    = DropdownStateMsg Dropdown.State
    | CoupletPhraseMsg CoupletPhrase


update : Msg -> Model -> Model
update msg model =
    case msg of
        DropdownStateMsg state ->
            { model | dropdownState = state }

        CoupletPhraseMsg coupletPhrase ->
            { model | coupletPhrase = coupletPhrase }



---- VIEW ----


view : Model -> Html.Html Msg
view model =
    Dropdown.view
        ("Couplet Phrase: " ++ CoupletPhrase.toString model.coupletPhrase)
        DropdownStateMsg
        model.dropdownState
        (CoupletPhrase.all |> List.map (\cp -> ( CoupletPhraseMsg cp, CoupletPhrase.toString cp )))



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.dropdownState DropdownStateMsg ]
