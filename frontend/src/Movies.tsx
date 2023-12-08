import { useQuery } from "@apollo/client"
import { Link } from "react-router-dom"
import slugify from "slugify"
import { graphql } from "./gql"

const MOVIES = graphql(`
  query Movies {
    movies {
      id
      name
      released
      actors {
        id
      }
    }
  }
`)

export default function Movies() {
  const { loading, error, data } = useQuery(MOVIES)

  if (loading) return <p>Loading...</p>
  if (error) return <p>Error {JSON.stringify(error)}</p>
  if (!data) return <p>Error :(</p>

  console.log(data.movies[0].actors)

  return (
    <div>
      <ul>
        {data.movies.map((movie) => (
          <Link to={`movie/${movie.id}/${slugify(movie.name)}`} key={movie.id}>
            <li>
              {movie.released} - {movie.name}
            </li>
          </Link>
        ))}
      </ul>
    </div>
  )
}
