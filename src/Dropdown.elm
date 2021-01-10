module Dropdown exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Utilities.Size as Size
import Html
import Html.Events
import Metryx exposing (Metryx(..))
import Mode exposing (Mode(..))


view : String -> (Dropdown.State -> msg) -> Dropdown.State -> List ( msg, String ) -> Html.Html msg
view name toggleMsg state items =
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
