using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddPooledDbContextFactory<GraphQL.DemoContext>(
    options => options.UseInMemoryDatabase("test")
);
builder.Services
    .AddGraphQLServer()
    .AddQueryType<Test.Query>()
    .AddFiltering()
    .AddProjections()
    .AddSorting()
    .RegisterDbContext<GraphQL.DemoContext>(DbContextKind.Pooled)
    .ModifyRequestOptions(opt => opt.IncludeExceptionDetails = builder.Environment.IsDevelopment());

builder.Services.AddCors();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}
else
{
    app.UseDeveloperExceptionPage();
    app.UseCors(options =>
        options.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin()
    );
}

app.UseStaticFiles();
app.UseRouting();
app.MapGraphQL();

using (var context = app.Services.GetRequiredService<IDbContextFactory<GraphQL.DemoContext>>().CreateDbContext())
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
            Id = 1,
            Name = "The Departed",
            Genre = GraphQL.Genre.Action,
            Rating = 9.5,
            Released = DateOnly.Parse("2006-10-06"),
            Actors = new List<GraphQL.Person>() {
                leonardoDiCaprio
            }
        },
        new GraphQL.Movie()
        {
            Id = 2,
            Name = "Inception",
            Genre = GraphQL.Genre.Action,
            Rating = 10,
            Released = DateOnly.Parse("2010-07-16"),
            Actors = new List<GraphQL.Person>() {
                leonardoDiCaprio,
                tomHardy
            }
        },
        new GraphQL.Movie()
        {
            Id = 3,
            Name = "Dunkirk",
            Genre = GraphQL.Genre.Drama,
            Rating = 9.7,
            Released = DateOnly.Parse("2017-07-21"),
            Actors = new List<GraphQL.Person>() {
                tomHardy
            }
        }
    );
    context.SaveChanges();
}

app.Run();