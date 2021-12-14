import { gql, useQuery } from '@apollo/client'
import { useEffect } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import slugify from './slugify'

const ACTOR = gql`
  query Actor($actorId: ID!) {
    person(id: $actorId) {
      id
      firstName
      lastName
      movies {
        id
        name
      }
    }
  }
`

interface IActor {
  id: string
  firstName: string
  lastName: string
  movies: {
    id: string
    name: string
  }[]
}

export default function ActorDetails() {
  const { actorId, name } = useParams<'actorId' | 'name'>()
  const navigate = useNavigate()

  const { loading, error, data } = useQuery<{ person: IActor }>(ACTOR, {
    variables: { actorId: actorId },
  })

  // Redirect if missing url-name
  useEffect(() => {
    if (loading || error || !data) return

    if (!name)
      navigate(
        `/actor/${data.person.id}/${slugify(`${data.person.firstName} ${data.person.lastName}`)}`,
      )
  }, [loading, error, data, name, navigate])

  if (loading) return <p>LOADING...</p>
  if (error) return <p>Error: {JSON.stringify(error)}</p>
  if (!data) return <p>Error :(</p>

  return (
    <div>
      <button onClick={() => navigate('..')}>go back</button>
      <h1>
        {data.person.firstName} {data.person.lastName}
      </h1>
      <ul>
        {data.person.movies.map((movie) => (
          <Link key={movie.id} to={`/movie/${movie.id}/${slugify(movie.name)}`}>
            <li>{movie.name}</li>
          </Link>
        ))}
      </ul>
    </div>
  )
}
