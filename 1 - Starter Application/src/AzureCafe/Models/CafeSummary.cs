namespace AzureCafe.Models
{
    public class CafeSummary
    {

        public CafeSummary(int cafeId, string? name, string? description, string? location, int? ratingCount, double? averageRating)
        {
            CafeId = cafeId;
            Name = name;
            Description = description;
            Location = location;
            RatingCount = ratingCount;
            AverageRating = averageRating;
        }


        public int CafeId { get; set; }

        public string? Name { get; set; }

        public string? Description { get; set; }

        public string? Location { get; set; }

        public int? RatingCount { get; set; }

        public double? AverageRating { get; set; }
    }

}
