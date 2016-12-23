module Tests exposing (..)

import Test exposing (..)
import Expect
import Http
import BasicAuth


all : Test
all =
    describe "BasicAuth"
        [ describe "String token"
            [ test "Builds a valid token from provided username and password" <|
                \() ->
                    Expect.equal (BasicAuth.buildAuthorizationToken "foo" "bar") "Zm9vOmJhcg=="
            , test "Builds a valid token from empty username and password" <|
                \() ->
                    Expect.equal (BasicAuth.buildAuthorizationToken "" "") "Og=="
            , test "Builds a valid token from only username" <|
                \() ->
                    Expect.equal (BasicAuth.buildAuthorizationToken "foo" "") "Zm9vOg=="
            ]
        , describe "Http header"
            [ test "Builds a valid header from provided username and password" <|
                \() ->
                    Expect.equal (BasicAuth.buildAuthorizationHeader "foo" "bar") (Http.header "Authorization" "Basic Zm9vOmJhcg==")
            , test "Builds a valid header from empty username and password" <|
                \() ->
                    Expect.equal (BasicAuth.buildAuthorizationHeader "" "") (Http.header "Authorization" "Basic Og==")
            , test "Builds a valid header from only username" <|
                \() ->
                    Expect.equal (BasicAuth.buildAuthorizationHeader "foo" "") (Http.header "Authorization" "Basic Zm9vOg==")
            ]
        ]
