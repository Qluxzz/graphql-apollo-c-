module Api.Enum.Genre exposing (Genre(..), all, decoder, encode)

{-| 
@docs encode, decoder, all, Genre
-}


import Json.Decode
import Json.Encode


type Genre
    = ACTION
    | DRAMA
    | COMEDY
    | HORROR
    | SCIFI


all : List Genre
all =
    [ ACTION, DRAMA, COMEDY, HORROR, SCIFI ]


decoder : Json.Decode.Decoder Genre
decoder =
    Json.Decode.andThen
        (\andThenUnpack ->
            case andThenUnpack of
                "ACTION" ->
                    Json.Decode.succeed ACTION

                "DRAMA" ->
                    Json.Decode.succeed DRAMA

                "COMEDY" ->
                    Json.Decode.succeed COMEDY

                "HORROR" ->
                    Json.Decode.succeed HORROR

                "SCIFI" ->
                    Json.Decode.succeed SCIFI

                _ ->
                    Json.Decode.fail "Invalid type"
        )
        Json.Decode.string


encode : Genre -> Json.Encode.Value
encode val =
    case val of
        ACTION ->
            Json.Encode.string "ACTION"

        DRAMA ->
            Json.Encode.string "DRAMA"

        COMEDY ->
            Json.Encode.string "COMEDY"

        HORROR ->
            Json.Encode.string "HORROR"

        SCIFI ->
            Json.Encode.string "SCIFI"


