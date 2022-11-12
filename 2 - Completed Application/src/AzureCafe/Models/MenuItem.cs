using System.ComponentModel.DataAnnotations;

namespace AzureCafe.Models
{
    public class MenuItem
    {
        public int ItemId { get; set; }

        public int CafeId { get; set; }

        [Required]
        public string Name { get; set; }

        public string? Description { get; set; }

        public decimal Price { get; set; }

    }
}
