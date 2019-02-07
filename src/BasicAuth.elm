module BasicAuth exposing
    ( buildAuthorizationHeader
    , buildAuthorizationToken
    )

{-| A helper library for Elm that provides building basic authentication token and header.


# Http header

@docs buildAuthorizationHeader


# Just the string token

@docs buildAuthorizationToken

-}

import Base64
import Http


{-| Builds an authorization header based on provided username and password.
This can be put directly into the Http.request headers array.

    loadAuthenticated : Int -> Cmd Msg
    loadAuthenticated id =
        let
            url =
                "https://reqres.in/api/users/" ++ toString id

            request =
                Http.request
                    { method = "GET"
                    , headers =
                        [ buildAuthorizationHeader "username" "password" ]
                    , url = url
                    , body = Http.emptyBody
                    , expect = Http.expectJson userDecoder
                    , timeout = Nothing
                    , withCredentials = False
                    }
        in
        Http.send UserResult request

-}
buildAuthorizationHeader : String -> String -> Http.Header
buildAuthorizationHeader username password =
    Http.header "Authorization" ("Basic " ++ buildAuthorizationToken username password)


{-| Builds just the authorization token based on provided username and password.
Use this if you need just the token for some reason.
Use buildAuthorizationHeader if you need the header anyway.
-}
buildAuthorizationToken : String -> String -> String
buildAuthorizationToken username password =
    Base64.encode (username ++ ":" ++ password)
