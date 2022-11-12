using AzureCafe.Models;
using Microsoft.EntityFrameworkCore;
using System.Linq;


namespace AzureCafe.Data
{
    public class AzureCafeContext : DbContext
    {

        public AzureCafeContext(DbContextOptions options) : base(options)
        {

        }


        public DbSet<Cafe> Cafes { get; set; }

        public DbSet<CafeSummary> CafeSummaries { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            ConfigureCafeModel(modelBuilder);
            ConfigureMenuItemModel(modelBuilder);
            ConfigureReviewModel(modelBuilder);
            ConfigureCafeSummaryModel(modelBuilder);
        }


        private void ConfigureCafeModel(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Cafe>()
                .HasKey(c => c.CafeId);
        }


        private void ConfigureMenuItemModel(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<MenuItem>()
                .ToTable("MenuItems")
                .HasKey(i => i.ItemId);
        }


        private void ConfigureReviewModel(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Review>()
                .ToTable("CafeReviews")
                .HasKey(r => r.ReviewId);
        }

        private void ConfigureCafeSummaryModel(ModelBuilder modelBuilder)
        {


            modelBuilder.Entity<CafeSummary>().HasNoKey().ToQuery(
                () => Cafes.Select(c => new CafeSummary(
                        c.CafeId,
                        c.Name,
                        c.Description,
                        c.Location,
                        c.Reviews.Count(),
                        c.Reviews.Average(r => r.Rating)
                        )
                    )
                );
        }



    }
}
