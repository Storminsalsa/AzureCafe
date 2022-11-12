using System.ComponentModel.DataAnnotations;

namespace AzureCafe.Models
{
    public class CreateReviewModel
    {



        [Required]
        public int CafeId { get; set; }

        [Required]
        [MaxLength(30)]
        public string ReviewerName { get; set; }

        [Required]
        [Range(1, 5)]
        public short Rating { get; set; }

        [MaxLength(512)]
        public string? Comments { get; set; }


        public IFormFile? ReviewPhoto { get; set; }
    }
}
