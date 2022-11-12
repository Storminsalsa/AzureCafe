using System.ComponentModel.DataAnnotations;

namespace AzureCafe.Models
{
    public class Review
    {

        public int ReviewId { get; set; }

        [Required]
        public int CafeId { get; set; }

        public Cafe Cafe { get; set; }

        [Required]
        public DateTime ReviewDate { get; set; }

        [Required]
        [MaxLength(30)]
        public string ReviewerName { get; set; }

        [Required]
        [Range(1, 5)]
        public short Rating { get; set; }

        [MaxLength(512)]
        public string? Comments { get; set; }


        public string? CommentsSentiment { get; set; }


        public string? ReviewPhotoName { get; set; }



    }
}
