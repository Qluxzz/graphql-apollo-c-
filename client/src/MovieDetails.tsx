import { useQuery } from "@apollo/client"
import { useEffect } from "react"
import { useParams, useNavigate, Link } from "react-router-dom"
import { graphql } from "./gql"
import slugify from "./slugify"

const MOVIE = graphql(`
  query Movie($movieId: Int!) {
    movie(id: $movieId) {
      id
      name
      genre
      released
      actors {
        id
        firstName
        lastName
      }
    }
  }
`)

export default function MovieDetails() {
  const { movieId, name } = useParams<"movieId" | "name">()

  if (!movieId) throw new Error()

  const navigate = useNavigate()

  const { loading, error, data } = useQuery(MOVIE, {
    variables: { movieId: parseInt(movieId) },
  })

  // Redirect if missing url name
  useEffect(() => {
    if (loading || error || !data || !data.movie) return

    if (!name) navigate(`/movie/${data.movie.id}/${slugify(data.movie.name)}`)
  }, [loading, error, data, name, navigate])

  if (loading) return <p>Loading...</p>
  if (error) return <p>Error {JSON.stringify(error)}</p>
  if (!data || !data.movie) return <p>Error :(</p>

  console.log(JSON.stringify(data))

  return (
    <div>
      <button onClick={() => navigate("..")}>go back</button>
      <h1>{data.movie.name}</h1>
      <table>
        <tbody>
          <tr>
            <td>Released</td>
            <td>{new Date(data.movie.released).toISOString().split("T")[0]}</td>
          </tr>
          <tr>
            <td>Genre</td>
            <td>{data.movie.genre}</td>
          </tr>
        </tbody>
      </table>
      <section>
        <h3>Actors</h3>
        <ul style={{ listStyle: "none", padding: 0 }}>
          {data.movie.actors.map((actor) => (
            <Link
              key={actor.id}
              to={`/actor/${actor.id}/${slugify(
                `${actor.firstName} ${actor.lastName}`
              )}`}
            >
              <li>
                {actor.firstName} {actor.lastName}
              </li>
            </Link>
          ))}
        </ul>
      </section>
    </div>
  )
}
