using EntityGraphQL.AspNet;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<GraphQL.DemoContext>();
builder.Services.AddGraphQLSchema<GraphQL.DemoContext>();
builder.Services.AddCors();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}
else
{
    app.UseCors(options =>
        options.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin()
    );
}

app.UseStaticFiles();
app.UseRouting();
app.UseEndpoints(endpoints =>
{
    endpoints.MapGraphQL<GraphQL.DemoContext>();
});

using (var context = new GraphQL.DemoContext())
{
    var leonardoDiCaprio = new GraphQL.Person()
    {
        Id = 1,
        FirstName = "Leonardo",
        LastName = "DiCaprio"
    };

    var tomHardy = new GraphQL.Person()
    {
        Id = 2,
        FirstName = "Tom",
        LastName = "Hardy"
    };

    context.Movies.AddRange(
        new GraphQL.Movie()
        {
            Name = "The Departed",
            Genre = GraphQL.Genre.Action,
            Rating = 9.5,
            Released = DateTime.Parse("2006-10-06"),
            Actors = new List<GraphQL.Person>() {
                leonardoDiCaprio
            }
        },
        new GraphQL.Movie()
        {
            Name = "Inception",
            Genre = GraphQL.Genre.Action,
            Rating = 10,
            Released = DateTime.Parse("2010-07-16"),
            Actors = new List<GraphQL.Person>() {
                leonardoDiCaprio,
                tomHardy
            }
        },
        new GraphQL.Movie()
        {
            Name = "Dunkirk",
            Genre = GraphQL.Genre.Drama,
            Rating = 9.7,
            Released = DateTime.Parse("2017-07-21"),
            Actors = new List<GraphQL.Person>() {
                tomHardy
            }
        }
    );
    context.SaveChanges();
}

app.Run();