using EntityGraphQL.AspNet.Extensions;
using EntityGraphQL.ServiceCollectionExtensions;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<GraphQL.DemoContext>();
builder.Services.AddGraphQLSchema<GraphQL.DemoContext>();
builder.Services.AddCors();

var app = builder.Build();

if (!app.Environment.IsDevelopment()) {
    app.UseExceptionHandler("/Error");
    app.UseHsts();
} else {
    app.UseCors(options => 
        options.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin()
    );
}

app.UseStaticFiles();
app.UseRouting();
app.UseEndpoints(endpoints => {
    endpoints.MapGraphQL<GraphQL.DemoContext>();
});

using (var context = new GraphQL.DemoContext()) {
    var leonardoDiCaprio = new GraphQL.Person() { 
        Id = 1,
        FirstName = "Leonardo",
        LastName = "DiCaprio" 
    };

    context.Movies.Add(new GraphQL.Movie() {
        Name = "The Departed",
        Genre = GraphQL.Genre.Action,
        Rating = 9.5,
        Released = DateTime.Parse("2006-10-06"),
        Actors = new List<GraphQL.Person>() {
            leonardoDiCaprio
        }
    });
    context.Movies.Add(new GraphQL.Movie() {
        Name = "Inception",
        Genre = GraphQL.Genre.Action,
        Rating = 10,
        Released = DateTime.Parse("2010-07-16"),
        Actors = new List<GraphQL.Person>() {
            leonardoDiCaprio
        }
    });
    context.SaveChanges();
}

app.Run();