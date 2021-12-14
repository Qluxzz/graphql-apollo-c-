import { gql, useQuery } from '@apollo/client'
import { useEffect } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import slugify from './slugify'

const MOVIE = gql`
  query Movie($movieId: ID!) {
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
`

interface IMovie {
  id: string
  name: string
  released: string
  genre: string
  actors: {
    id: string
    firstName: string
    lastName: string
  }[]
}

export default function MovieDetails() {
  const { movieId, name } = useParams<'movieId' | 'name'>()
  const navigate = useNavigate()

  const { loading, error, data } = useQuery<{ movie: IMovie }>(MOVIE, {
    variables: { movieId: movieId },
  })

  // Redirect if missing url name
  useEffect(() => {
    if (loading || error || !data) return

    if (!name) navigate(`/movie/${data.movie.id}/${slugify(data.movie.name)}`)
  }, [loading, error, data, name, navigate])

  if (loading) return <p>Loading...</p>
  if (error) return <p>Error {JSON.stringify(error)}</p>
  if (!data) return <p>Error :(</p>

  return (
    <div>
      <button onClick={() => navigate('..')}>go back</button>
      <h1>{data.movie.name}</h1>
      <table>
        <tbody>
          <tr>
            <td>Released</td>
            <td>{new Date(data.movie.released).toISOString().split('T')[0]}</td>
          </tr>
          <tr>
            <td>Genre</td>
            <td>{data.movie.genre}</td>
          </tr>
        </tbody>
      </table>
      <section>
        <h3>Actors</h3>
        <ul style={{ listStyle: 'none', padding: 0 }}>
          {data.movie.actors.map((actor) => (
            <Link
              key={actor.id}
              to={`/actor/${actor.id}/${slugify(
                `${actor.firstName} ${actor.lastName}`,
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
