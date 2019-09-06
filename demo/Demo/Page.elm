module Demo.Page exposing
    ( Page
    , demos
    , drawer
    , subheader
    , topappbar
    , componentCatalogPanel
    )

import Demo.Helper.Hero as Hero
import Demo.Url as Url exposing (Url)
import Html exposing (Html, div, h2, span, section, text)
import Html.Attributes as Html
import Material
import Material.Drawer.Modal as Drawer
import Material.Icon as Icon
import Material.Options as Options exposing (Property, cs, css, styled, when)
import Material.List as Lists
import Material.TopAppBar as TopAppBar
import Material.Typography as Typography


type alias Page m =
    { topappbar : String -> Html m
    , navigate : Url -> m
    , body : String -> String -> Html m -> List (Html m) -> Html m
    }


topappbar :
    (Material.Msg m -> m)
    -> Material.Index
    -> Material.Model m
    -> m
    -> Url
    -> String
    -> Html m
topappbar lift idx mdc cmd url title =
    TopAppBar.view lift
        idx
        mdc
        [ cs "catalog-top-app-bar"
        ]
        [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ case url of
                  Url.StartPage ->
                      styled Html.img
                          [ cs "mdc-toolbar__menu-icon"
                          , Options.attribute (Html.src "images/ic_component_24px_white.svg")
                          ]
                          []

                  _ ->
                      TopAppBar.navigationIcon lift "my-menu" mdc
                          [ Options.onClick cmd ]
                          "menu"
            , TopAppBar.title
                [ cs "catalog-top-app-bar__title"
                ]
                ( if url == Url.StartPage then
                      [ styled span [ cs "catalog-top-app-bar__title--small-screen" ] [ text "MDC Web" ],
                            styled span [ cs "catalog-top-app-bar__title--large-screen" ] [ text title ]
                      ]
                  else
                      [ text "Material Components for the Web" ]
                )
            ]
        ]


drawer :
    (Material.Msg m -> m)
    -> Material.Index
    -> Material.Model m
    -> m
    -> Url
    -> Bool
    -> Html m
drawer lift idx mdc cmd current_url open =
    let
        a title url =
            listItem title url current_url
    in
    Drawer.view lift
        idx
        mdc
        [ Drawer.open |> when open
        , Drawer.onClose cmd
        -- we need this when we switch between modal and dismissible drawer: #233
        -- , TopAppBar.fixedAdjust
        -- , css "z-index" "1"
        ]
        [ Drawer.header
              [ css "padding-top" "18px"
              , css "opacity" ".74"
              ]
              [ styled Html.img
                    [ Options.attribute (Html.src "https://material-components.github.io/material-components-web-catalog/static/media/ic_material_design_24px.svg")
                    ]
                    [ ]
              ]
        , Drawer.content []
            [ Lists.nav lift "drawer-list" mdc []
                  [ Lists.a
                        [ Options.attribute (Html.href "#")
                        ]
                        [ text "Home"
                        ]
                  , a "Button" Url.Button
                  , a "Card" Url.Card
                  , a "Checkbox" Url.Checkbox
                  , a "Chips" Url.Chips
                  , a "Data Table" Url.DataTable
                  , a "Dialog" Url.Dialog
                  , a "Drawer" Url.Drawer
                  , a "Elevation" Url.Elevation
                  , a "FAB" Url.Fabs
                  , a "Icon Button" Url.IconButton
                  , a "Image List" Url.ImageList
                  , a "Layout Grid" Url.LayoutGrid
                  , a "Linear Progress Indicator" Url.LinearProgress
                  , a "List" Url.List
                  , a "Menu" Url.Menu
                  , a "Radio Button" Url.RadioButton
                  , a "Ripple" Url.Ripple
                  , a "Select" Url.Select
                  , a "Slider" Url.Slider
                  , a "Snackbar" Url.Snackbar
                  , a "Switch" Url.Switch
                  , a "Tab Bar" Url.TabBar
                  , a "Text Field" Url.TextField
                  , a "Theme" Url.Theme
                  , a "Top App Bar" (Url.TopAppBar Nothing)
                  , a "Typograpy" Url.Typography
                  ]
            ]
        ]


listItem title url current_url =
    Lists.a
        [ Options.attribute (Html.href (Url.toString url))
        , Lists.activated |> when  ( current_url == url )
        ]
        [ text title
        ]


subheader : String -> Html m
subheader title =
    styled Html.h3
        [ Typography.subtitle1 ]
        [ text title ]


componentCatalogPanel : String -> String -> Html m -> List (Html m) -> Html m
componentCatalogPanel title intro hero nodes =
    styled section
        [ cs "component-catalog-panel"
        , css "margin-top" "24px"
        , css "padding-bottom" "24px"
        ]
        ( Hero.area title intro hero
        :: nodes
        )


demos : List (Html m) -> Html m
demos nodes =
    styled div
        [ css "padding-bottom" "20px" ]
        (styled h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Demos" ]
            :: nodes
        )
