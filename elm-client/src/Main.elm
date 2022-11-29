module Main exposing (Model, main)

import Actor.Actor exposing (Person)
import Api
import Browser
import Dict exposing (Dict)
import GraphQL.Engine
import Html as H
import Html.Events as HE
import Movie.Movie exposing (Movie)
import Process exposing (sleep)
import Task


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = MovieFetched (Result GraphQL.Engine.Error Movie.Movie.Response)
    | ActorFetched (Result GraphQL.Engine.Error Actor.Actor.Response)
    | LoadActor Int
    | LoadMovie Int
      -- Debounced loading state
      -- Shows the loader after a request has taken more than x amount of milliseconds
    | ShowLoader


type ShowLoader
    = Visible
    | Hidden


type Path
    = Actor Person
    | Movie Movie
    | Loading ShowLoader


type alias Model =
    { movies : Dict Int Movie
    , actors : Dict Int Person
    , selectedPath : Path
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { movies = Dict.empty
      , actors = Dict.empty
      , selectedPath = Loading Hidden
      }
    , Cmd.batch (getMovieById 1)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MovieFetched (Ok { movie }) ->
            case movie of
                Just m ->
                    ( { model | movies = Dict.insert m.id m model.movies, selectedPath = Movie m }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        MovieFetched (Err err) ->
            ( model, Cmd.none )

        ActorFetched (Ok { person }) ->
            case person of
                Just p ->
                    ( { model | actors = Dict.insert p.id p model.actors, selectedPath = Actor p }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ActorFetched (Err _) ->
            ( model, Cmd.none )

        LoadMovie id ->
            let
                ( p, cmd ) =
                    getCachedOrFetchMovie id model.movies
            in
            ( { model | selectedPath = p }, cmd )

        LoadActor id ->
            let
                ( p, cmd ) =
                    getCachedOrFetchActor id model.actors
            in
            ( { model | selectedPath = p }, cmd )

        ShowLoader ->
            case model.selectedPath of
                Loading _ ->
                    ( { model | selectedPath = Loading Visible }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Elm GQL"
    , body =
        [ case model.selectedPath of
            Actor actor ->
                actorView actor

            Movie movie ->
                movieView movie

            Loading Visible ->
                H.div [] [ H.text "Loading..." ]

            Loading Hidden ->
                H.text ""
        ]
    }


actorView : Person -> H.Html Msg
actorView actor =
    H.div []
        [ H.h1 [] [ H.text (actor.firstName ++ " " ++ actor.lastName) ]
        , H.ul []
            (List.map
                (\movie ->
                    H.li []
                        [ H.button [ HE.onClick (LoadMovie movie.id) ] [ H.text movie.name ]
                        ]
                )
                actor.movies
            )
        ]


movieView : Movie -> H.Html Msg
movieView movie =
    H.div []
        [ H.h1 [] [ H.text movie.name ]
        , H.ul []
            (List.map
                (\actor ->
                    H.li []
                        [ H.button [ HE.onClick (LoadActor actor.id) ] [ H.text (actor.firstName ++ " " ++ actor.lastName) ]
                        ]
                )
                movie.actors
            )
        , H.time []
            [ H.text
                (case movie.released of
                    Api.DateTime dateTime ->
                        dateTime
                )
            ]
        ]



-- HELPER FUNCTIONS


getCachedOrFetchMovie : Int -> Dict Int Movie -> ( Path, Cmd Msg )
getCachedOrFetchMovie =
    getCachedOrFetch getActorById Movie


getCachedOrFetchActor : Int -> Dict Int Person -> ( Path, Cmd Msg )
getCachedOrFetchActor =
    getCachedOrFetch getActorById Actor


getCachedOrFetch :
    (Int -> List (Cmd Msg))
    -> (a -> Path)
    -> Int
    -> Dict Int a
    -> ( Path, Cmd Msg )
getCachedOrFetch fetch p id dict =
    case Dict.get id dict of
        Just entry ->
            ( p entry, Cmd.none )

        Nothing ->
            ( Loading Hidden, Cmd.batch (fetch id) )


getActorById : Int -> List (Cmd Msg)
getActorById id =
    request ActorFetched (Actor.Actor.query { actorId = id })


getMovieById : Int -> List (Cmd Msg)
getMovieById id =
    request MovieFetched (Movie.Movie.query { movieId = id })


request : (Result GraphQL.Engine.Error value -> Msg) -> GraphQL.Engine.Selection GraphQL.Engine.Query value -> List (Cmd Msg)
request toMsg query =
    [ GraphQL.Engine.query query
        { headers = []
        , url = "http://localhost:5034/graphql"
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map toMsg
    , -- Debounce show loader to avoid one frame re-render with loading text
      sleep 200 |> Task.perform (\_ -> ShowLoader)
    ]
