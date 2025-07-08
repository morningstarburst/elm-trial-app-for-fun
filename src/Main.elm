module Main exposing (main)

import Browser
import Html exposing (Html, div, text, a, br)
import Html.Attributes exposing (href, target)
import Time exposing (Posix, Zone)
import Task

-- MODEL

type alias Model =
    { time : Posix
    , zone : Zone
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Time.millisToPosix 0) Time.utc
    , Time.here |> Task.perform GotZone
    )

-- UPDATE

type Msg
    = Tick Posix
    | GotZone Zone

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )
        GotZone zone ->
            ( { model | zone = zone }, Cmd.none )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick

-- VIEW

view : Model -> Html Msg
view model =
    let
        timeStr =
            let
                t = model.time
                z = model.zone
                hour = Time.toHour z t
                minute = Time.toMinute z t
                second = Time.toSecond z t
            in
            String.fromInt hour ++ ":"
                ++ String.padLeft 2 '0' (String.fromInt minute) ++ ":"
                ++ String.padLeft 2 '0' (String.fromInt second)
        dateStr =
            let
                t = model.time
                z = model.zone
                year = Time.toYear z t
                month = Time.toMonth z t |> monthToString
                day = Time.toDay z t
            in
            month ++ " " ++ String.fromInt day ++ ", " ++ String.fromInt year
    in
    div []
        [ div [] [ text ("Date: " ++ dateStr) ]
        , div [] [ text ("Time: " ++ timeStr) ]
        , br [] []
        , a [ href "https://www.toastmasters.org/", target "_blank" ] [ text "The Toastmasters" ]
        , br [] []
        , a [ href "https://www.wisc.edu/", target "_blank" ] [ text "University of Wisconsin" ]
        ]

monthToString : Time.Month -> String
monthToString month =
    case month of
        Time.Jan -> "January"
        Time.Feb -> "February"
        Time.Mar -> "March"
        Time.Apr -> "April"
        Time.May -> "May"
        Time.Jun -> "June"
        Time.Jul -> "July"
        Time.Aug -> "August"
        Time.Sep -> "September"
        Time.Oct -> "October"
        Time.Nov -> "November"
        Time.Dec -> "December"

-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
