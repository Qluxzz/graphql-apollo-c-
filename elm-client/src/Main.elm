module Main exposing (Model, main)

import Browser
import GraphQL.Engine
import Html
import Person.Movie exposing (Movie)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = MovieFetched (Result GraphQL.Engine.Error Person.Movie.Response)


type alias Model =
    { movie : Maybe Movie
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { movie = Nothing
      }
    , request MovieFetched (Person.Movie.query { movieId = 1 })
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MovieFetched (Ok { movie }) ->
            ( { model | movie = movie }, Cmd.none )

        MovieFetched (Err err) ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Elm GQL"
    , body =
        [ case model.movie of
            Nothing ->
                Html.div [] []

            Just movie ->
                Html.div []
                    [ Html.h1 [] [ Html.text movie.name ]
                    ]
        ]
    }


request : (Result GraphQL.Engine.Error value -> msg) -> GraphQL.Engine.Selection GraphQL.Engine.Query value -> Cmd msg
request toMsg query =
    GraphQL.Engine.query query
        { headers = []
        , url = "http://localhost:5034/graphql"
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map toMsg
