module Example exposing (Model, Msg(..), decodeGifUrl, init, loadUser, main, subscriptions, update, view)

import BasicAuth exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main =
    Browser.element
        { init = init 1
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { id : Int
    , avatarUrl : String
    }


init : Int -> () -> ( Model, Cmd Msg )
init id flags =
    ( Model id ""
    , loadUser id
    )



-- UPDATE


type Msg
    = MorePlease
    | UserResult (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            let
                newId =
                    model.id + 1
            in
            ( { model | id = newId }, loadUser newId )

        UserResult (Ok newUrl) ->
            ( { model | avatarUrl = newUrl }, Cmd.none )

        UserResult (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text ("User #" ++ String.fromInt model.id) ]
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , br [] []
        , img [ src model.avatarUrl ] []
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


loadUser : Int -> Cmd Msg
loadUser id =
    let
        url =
            "https://reqres.in/api/users/" ++ String.fromInt id
    in
    Http.request
        { method = "GET"
        , headers =
            -- add the authorization header
            [ buildAuthorizationHeader "username" "password" ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson UserResult decodeGifUrl
        , timeout = Nothing
        , tracker = Nothing
        }


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "avatar" ] Decode.string
