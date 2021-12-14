using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace GraphQL
{
    public class DemoContext : DbContext
    {
        public DemoContext()
        {
        }

        protected override void OnConfiguring(
            DbContextOptionsBuilder builder
        ) => builder.UseInMemoryDatabase("test");

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Entity<Movie>()
                .HasMany(movie => movie.Actors)
                .WithMany(person => person.Movies);
        }

        public DbSet<Movie> Movies { get; set; }

        public DbSet<Person> People { get; set; }
    }

    public class Person
    {
        [Key]
        public uint Id { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public List<Movie> Movies { get; set; }
    }

    public class Movie
    {
        [Key]
        public uint Id { get; set; }

        public string Name { get; set; }

        public Genre Genre { get; set; }

        public DateTime Released { get; set; }

        public double Rating { get; internal set; }

        public List<Person> Actors { get; set; }
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
