module Person.Movie exposing (Actors, Input, Movie, Response, query)

{-| 
This file is generated from src/person.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs query

@docs Actors, Movie


-}


import Api
import Api.Enum.Genre
import GraphQL.Engine
import Json.Decode
import Json.Encode


type alias Input =
    { movieId : Int }


query : Input -> Api.Query Response
query args =
    GraphQL.Engine.bakeToSelection
        (Just "Movie")
        (\version_ ->
            { args =
                GraphQL.Engine.inputObjectToFieldList
                    (GraphQL.Engine.inputObject "Input"
                        |> GraphQL.Engine.addField
                            "movieId"
                            "Int!"
                            (Json.Encode.int args.movieId)
                    )
            , body = toPayload_ version_
            , fragments = toFragments_ version_
            }
        )
        decoder_


{-  Return data  -}


type alias Response =
    { movie : Maybe Movie }


type alias Movie =
    { id : Int
    , name : String
    , genre : Api.Enum.Genre.Genre
    , released : Api.DateTime
    , actors : List Actors
    }


type alias Actors =
    { id : Int, firstName : String, lastName : String }


decoder_ : Int -> Json.Decode.Decoder Response
decoder_ version_ =
    Json.Decode.succeed Response
        |> GraphQL.Engine.versionedJsonField
            version_
            "movie"
            (GraphQL.Engine.decodeNullable
                (Json.Decode.succeed Movie
                    |> GraphQL.Engine.versionedJsonField 0 "id" Json.Decode.int
                    |> GraphQL.Engine.versionedJsonField
                        0
                        "name"
                        Json.Decode.string
                    |> GraphQL.Engine.versionedJsonField
                        0
                        "genre"
                        Api.Enum.Genre.decoder
                    |> GraphQL.Engine.versionedJsonField
                        0
                        "released"
                        Api.dateTime.decoder
                    |> GraphQL.Engine.versionedJsonField
                        0
                        "actors"
                        (Json.Decode.list
                            (Json.Decode.succeed Actors
                                |> GraphQL.Engine.versionedJsonField
                                    0
                                    "id"
                                    Json.Decode.int
                                |> GraphQL.Engine.versionedJsonField
                                    0
                                    "firstName"
                                    Json.Decode.string
                                |> GraphQL.Engine.versionedJsonField
                                    0
                                    "lastName"
                                    Json.Decode.string
                            )
                        )
                )
            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((GraphQL.Engine.versionedAlias version_ "movie" ++ " (id: ")
        ++ GraphQL.Engine.versionedName version_ "$movieId"
    )
        ++ """) {id
name
genre
released
actors {id
firstName
lastName } }"""


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []


