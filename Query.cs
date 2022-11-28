using Microsoft.EntityFrameworkCore;

public class Query
{
    public IEnumerable<GraphQL.Movie> GetMovies(GraphQL.DemoContext dbContext)
        => dbContext.Movies.Include(x => x.Actors).AsQueryable();

    public GraphQL.Movie? GetMovie(GraphQL.DemoContext dbContext, int id)
    {
        var query = dbContext.Movies
            .Include(x => x.Actors)
            .AsQueryable();

        query = query.Where(x => x.Id == id);

        return query.SingleOrDefault();
    }

    public GraphQL.Person? GetPerson(GraphQL.DemoContext dbContext, int id)
    {
        var query = dbContext.People.Include(x => x.Movies).AsQueryable();

        query = query.Where(x => x.Id == id);

        return query.SingleOrDefault();
    }


}