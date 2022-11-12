using System.ComponentModel.DataAnnotations;

namespace AzureCafe.Models
{
    public class Cafe
    {

        public int CafeId { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        public string Description { get; set; }

        [Required]
        public string Location { get; set; }

        public List<MenuItem> MenuItems { get; set; }

        public List<Review> Reviews { get; set; }



    }
}
