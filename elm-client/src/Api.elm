module Api exposing (DateTime(..), Mutation, Option, Query, absent, batch, dateTime, map, map2, mutation, null, present, query)

{-| 
This is a file generated by `elm-gql` when you ran `elm-gql init`!

It's yours now to do whatever you want with.

This file does include decoders and encoders for all the Scalars for your GQL endpoint.  You'll need to make sure they are implemented correctly.

## Queries

@docs query, Query

## Mutations

@docs mutation, Mutation

## Optional Inputs

@docs Option, present, absent, null

## Batching and Mapping

@docs map2, map, batch

## Scalar Decoders and Encoders

@docs dateTime, DateTime
-}


import GraphQL.Engine
import Http
import Json.Decode
import Json.Encode


type alias Query data =
    GraphQL.Engine.Selection GraphQL.Engine.Query data


type alias Mutation data =
    GraphQL.Engine.Selection GraphQL.Engine.Mutation data


type alias Selection source data =
    GraphQL.Engine.Selection source data


query :
    Query data
    -> { headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result GraphQL.Engine.Error data)
query sel options =
    GraphQL.Engine.query sel options


mutation :
    Mutation data
    -> { headers : List Http.Header
    , url : String
    , timeout : Maybe Float
    , tracker : Maybe String
    }
    -> Cmd (Result GraphQL.Engine.Error data)
mutation sel options =
    GraphQL.Engine.mutation sel options


null : Option value
null =
    GraphQL.Engine.Null


absent : Option value
absent =
    GraphQL.Engine.Absent


present : input -> Option input
present input =
    GraphQL.Engine.Present input


type alias Option input =
    GraphQL.Engine.Option input


batch : List (Selection source data) -> Selection source (List data)
batch =
    GraphQL.Engine.batch


map : (a -> b) -> Selection source a -> Selection source b
map =
    GraphQL.Engine.map


map2 :
    (a -> b -> c)
    -> Selection source a
    -> Selection source b
    -> Selection source c
map2 =
    GraphQL.Engine.map2


type alias Codec scalar =
    { encode : scalar -> Json.Encode.Value
    , decoder : Json.Decode.Decoder scalar
    }


type DateTime
    = DateTime String


dateTime : Codec DateTime
dateTime =
    { encode =
        \val ->
            case val of
                DateTime str ->
                    Json.Encode.string str
    , decoder = Json.Decode.map DateTime Json.Decode.string
    }


