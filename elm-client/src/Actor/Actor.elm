module Actor.Actor exposing (Input, Movies, Person, Response, query)

{-| 
This file is generated from src/actor.gql using `elm-gql`

Please avoid modifying directly.


@docs Input

@docs Response

@docs query

@docs Movies, Person


-}


import Api
import GraphQL.Engine
import Json.Decode
import Json.Encode


type alias Input =
    { actorId : Int }


query : Input -> Api.Query Response
query args =
    GraphQL.Engine.bakeToSelection
        (Just "Actor")
        (\version_ ->
            { args =
                GraphQL.Engine.inputObjectToFieldList
                    (GraphQL.Engine.inputObject "Input"
                        |> GraphQL.Engine.addField
                            "actorId"
                            "Int!"
                            (Json.Encode.int args.actorId)
                    )
            , body = toPayload_ version_
            , fragments = toFragments_ version_
            }
        )
        decoder_


{-  Return data  -}


type alias Response =
    { person : Maybe Person }


type alias Person =
    { id : Int, firstName : String, lastName : String, movies : List Movies }


type alias Movies =
    { id : Int, name : String }


decoder_ : Int -> Json.Decode.Decoder Response
decoder_ version_ =
    Json.Decode.succeed Response
        |> GraphQL.Engine.versionedJsonField
            version_
            "person"
            (GraphQL.Engine.decodeNullable
                (Json.Decode.succeed Person
                    |> GraphQL.Engine.versionedJsonField 0 "id" Json.Decode.int
                    |> GraphQL.Engine.versionedJsonField
                        0
                        "firstName"
                        Json.Decode.string
                    |> GraphQL.Engine.versionedJsonField
                        0
                        "lastName"
                        Json.Decode.string
                    |> GraphQL.Engine.versionedJsonField
                        0
                        "movies"
                        (Json.Decode.list
                            (Json.Decode.succeed Movies
                                |> GraphQL.Engine.versionedJsonField
                                    0
                                    "id"
                                    Json.Decode.int
                                |> GraphQL.Engine.versionedJsonField
                                    0
                                    "name"
                                    Json.Decode.string
                            )
                        )
                )
            )


toPayload_ : Int -> String
toPayload_ version_ =
    ((GraphQL.Engine.versionedAlias version_ "person" ++ " (id: ")
        ++ GraphQL.Engine.versionedName version_ "$actorId"
    )
        ++ """) {id
firstName
lastName
movies {id
name } }"""


toFragments_ : Int -> String
toFragments_ version_ =
    String.join """
""" []


