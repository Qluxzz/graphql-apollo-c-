import { useQuery } from "@apollo/client"
import { useEffect } from "react"
import { useParams, useNavigate, Link } from "react-router-dom"
import { graphql } from "./gql"
import slugify from "./slugify"

const ACTOR = graphql(`
  query Actor($actorId: Int!) {
    person(id: $actorId) {
      id
      firstName
      lastName
      movies {
        items {
          id
          name
        }
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
    if (loading || error || !data || !data.person) return

    if (!name)
      navigate(
        `/actor/${data.person.id}/${slugify(
          `${data.person.firstName} ${data.person.lastName}`
        )}`
      )
  }, [loading, error, data, name, navigate])

  if (loading) return <p>LOADING...</p>
  if (error) return <p>Error: {JSON.stringify(error)}</p>
  if (!data || !data.person) return <p>Error :(</p>

  return (
    <div>
      <button onClick={() => navigate("..")}>go back</button>
      <h1>
        {data.person.firstName} {data.person.lastName}
      </h1>
      <ul>
        {data.person.movies?.items.map((movie) => (
          <Link key={movie.id} to={`/movie/${movie.id}/${slugify(movie.name)}`}>
            <li>{movie.name}</li>
          </Link>
        ))}
      </ul>
    </div>
  )
}
