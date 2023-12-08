import { useQuery } from "@apollo/client"
import { useEffect } from "react"
import { useParams, useNavigate, Link } from "react-router-dom"
import { graphql } from "./gql"
import slugify from "./slugify"

const ACTOR = graphql(`
  query Actor($actorId: Int!) {
    actor(where: { id: { eq: $actorId } }) {
      id
      firstName
      lastName
      movies {
        id
        name
      }
    }
  }
`)

export default function ActorDetails() {
  const { actorId, name } = useParams<"actorId" | "name">()
  if (!actorId) throw new Error()

  const navigate = useNavigate()

  const { loading, error, data } = useQuery(ACTOR, {
    variables: { actorId: parseInt(actorId) },
  })

  // Redirect if missing url-name
  useEffect(() => {
    if (loading || error || !data || !data.actor) return

    if (!name)
      navigate(
        `/actor/${data.actor.id}/${slugify(
          `${data.actor.firstName} ${data.actor.lastName}`
        )}`
      )
  }, [loading, error, data, name, navigate])

  if (loading) return <p>LOADING...</p>
  if (error) return <p>Error: {JSON.stringify(error)}</p>
  if (!data || !data.actor) return <p>Error :(</p>

  return (
    <div>
      <button onClick={() => navigate("..")}>go back</button>
      <h1>
        {data.actor.firstName} {data.actor.lastName}
      </h1>
      <ul>
        {data.actor.movies.map((movie) => (
          <Link key={movie.id} to={`/movie/${movie.id}/${slugify(movie.name)}`}>
            <li>{movie.name}</li>
          </Link>
        ))}
      </ul>
    </div>
  )
}
