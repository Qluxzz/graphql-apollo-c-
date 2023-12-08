namespace Test;


public class Query
{
    /// <summary>
    /// Gets all movies
    /// </summary>
    /// <returns></returns>
    [UseProjection]
    [UseFiltering]
    [UseSorting]
    public IQueryable<GraphQL.Movie> GetMovies(GraphQL.DemoContext dbContext)
        => dbContext.Movies;

    /// <summary>
    /// Get movie
    /// </summary>
    /// <returns></returns>
    [UseSingleOrDefault]
    [UseProjection]
    [UseFiltering]
    [UseSorting]
    public IQueryable<GraphQL.Movie> GetMovie(GraphQL.DemoContext dbContext)
        => dbContext.Movies;

    /// <summary>
    /// Gets all actors
    /// </summary>
    /// <param name="dbContext"></param>
    /// <returns></returns>
    [UseProjection]
    [UseFiltering]
    public IQueryable<GraphQL.Person> GetActors(GraphQL.DemoContext dbContext)
        => dbContext.People;

    /// <summary>
    /// Get actor
    /// </summary>
    /// <param name="dbContext"></param>
    /// <returns></returns>
    [UseSingleOrDefault]
    [UseProjection]
    [UseFiltering]
    public IQueryable<GraphQL.Person> GetActor(GraphQL.DemoContext dbContext)
        => dbContext.People;
}