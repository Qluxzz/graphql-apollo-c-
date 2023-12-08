import { ApolloClient, ApolloProvider, InMemoryCache } from "@apollo/client"
import { BrowserRouter, Route, Routes } from "react-router-dom"
import ActorDetails from "./ActorDetails"
import MovieDetails from "./MovieDetails"
import Movies from "./Movies"

const client = new ApolloClient({
  uri: "http://localhost:5034/graphql",
  cache: new InMemoryCache(),
  connectToDevTools: true,
})

function App() {
  return (
    <ApolloProvider client={client}>
      <BrowserRouter>
        <div className="App">
          <Routes>
            <Route index element={<Movies />} />
            <Route path="movie/:movieId" element={<MovieDetails />}>
              <Route path=":name" element={<MovieDetails />} />
            </Route>
            <Route path="actor/:actorId" element={<ActorDetails />}>
              <Route path=":name" element={<ActorDetails />} />
            </Route>
          </Routes>
        </div>
      </BrowserRouter>
    </ApolloProvider>
  )
}

export default App
