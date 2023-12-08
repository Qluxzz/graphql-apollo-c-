using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace GraphQL
{
    public class DemoContext : DbContext
    {
        public DemoContext(DbContextOptions<DemoContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Entity<Movie>()
                .HasMany(movie => movie.Actors)
                .WithMany(person => person.Movies);
        }

        public virtual DbSet<Movie> Movies { get; set; } = null!;

        public virtual DbSet<Person> People { get; set; } = null!;
    }

    public class Person
    {
        [Key]
        public int Id { get; set; }

        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public List<Movie> Movies { get; set; } = new List<Movie>();
    }

    public class Movie
    {
        [Key]
        public int Id { get; set; }

        public string Name { get; set; } = null!;

        public Genre Genre { get; set; }

        public DateOnly Released { get; set; }

        public double Rating { get; internal set; }

        public List<Person> Actors { get; set; } = new List<Person>();
    }

    public enum Genre
    {
        Action,
        Drama,
        Comedy,
        Horror,
        Scifi
    }
}
