import { gql, useQuery } from '@apollo/client'
import { Link } from 'react-router-dom'
import slugify from 'slugify'

const MOVIES = gql`
  query Movies {
    movies {
      id
      name
    }
  }
`

interface IMovieListEntry {
  id: string
  name: string
}

export default function Movies() {
  const { loading, error, data } = useQuery<{ movies: IMovieListEntry[] }>(MOVIES)

  if (loading) return <p>Loading...</p>
  if (error) return <p>Error {JSON.stringify(error)}</p>
  if (!data) return <p>Error :(</p>

  return (
    <div>
      <ul>
        {data.movies.map((movie) => (
          <Link to={`movie/${movie.id}/${slugify(movie.name)}`} key={movie.id}>
            <li>
              {movie.id} {movie.name}
            </li>
          </Link>
        ))}
      </ul>
    </div>
  )
}
