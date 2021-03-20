module Dropdown.View exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Utilities.Size as Size
import Html
import Html.Attributes
import Html.Events


view : Html.Html msg -> (Dropdown.State -> msg) -> Dropdown.State -> List ( msg, Html.Html msg ) -> Html.Html msg
view name toggleMsg state items =
    Dropdown.dropdown
        state
        { options = [ Dropdown.attrs [ Size.w100, Html.Attributes.style "max-width" "300px" ] ]
        , toggleMsg = toggleMsg
        , toggleButton =
            Dropdown.toggle [ Button.outlinePrimary, Button.large ] [ name ]
        , items =
            items
                |> List.map
                    (\( msg, html ) ->
                        Dropdown.buttonItem [ Html.Events.onClick msg ] [ html ]
                    )
        }
