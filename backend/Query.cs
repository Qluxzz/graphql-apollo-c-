using Microsoft.EntityFrameworkCore;

public class Query
{
    public IQueryable<GraphQL.Movie> GetMovies(GraphQL.DemoContext dbContext)
        => dbContext
            .Movies
            .Include(x => x.Actors)
            .AsQueryable();

    public IQueryable<GraphQL.Person> GetActors(GraphQL.DemoContext dbContext)
        => dbContext
            .People
            .Include(x => x.Movies)
            .AsQueryable();

    public GraphQL.Movie? GetMovie(GraphQL.DemoContext dbContext, int id)
        => dbContext
            .Movies
            .Include(x => x.Actors)
            .SingleOrDefault(x => x.Id == id);

    public GraphQL.Person? GetPerson(GraphQL.DemoContext dbContext, int id)
        => dbContext
            .People
            .Include(x => x.Movies)
            .SingleOrDefault(x => x.Id == id);
}