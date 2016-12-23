module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import BasicAuth exposing (..)


main =
    Html.program
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


init : Int -> ( Model, Cmd Msg )
init id =
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
            ( Model model.id newUrl, Cmd.none )

        UserResult (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text ("User #" ++ (toString model.id)) ]
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
            "https://reqres.in/api/users/" ++ (toString id)

        request =
            Http.request
                { method = "GET"
                , headers =
                    -- add the authorization header
                    [ buildAuthorizationHeader "username" "password" ]
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson decodeGifUrl
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send UserResult request


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "avatar" ] Decode.string
