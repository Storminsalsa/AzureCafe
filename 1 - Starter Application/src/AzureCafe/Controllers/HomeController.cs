using Azure.AI.TextAnalytics;
using Azure.Storage.Blobs;
using AzureCafe.Data;
using AzureCafe.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;
using System.IO;

namespace AzureCafe.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private AzureCafeContext _cafeContext;
        private BlobContainerClient _blobContainerClient;
        private TextAnalyticsClient _textAnalyticsClient;

        public HomeController(ILogger<HomeController> logger, AzureCafeContext context, BlobContainerClient blobContainerClient, TextAnalyticsClient textAnalyticsClient)
        {
            _logger = logger;
            _cafeContext = context;
            _blobContainerClient = blobContainerClient;
            _textAnalyticsClient = textAnalyticsClient;
        }

        public IActionResult Index()
        {
            var cafes = _cafeContext.CafeSummaries.ToList();
            return View(cafes);
        }



        public ActionResult Details(int id)
        {
            var cafe = _cafeContext.Cafes
                .Include(c => c.MenuItems)
                .Include(c => c.Reviews)
                .Where(c => c.CafeId == id).FirstOrDefault();
            ViewBag.BaseImagePath = _blobContainerClient.Uri.ToString();
            return View(cafe);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateReview(int id, CreateReviewModel model)
        {
            var cafe = _cafeContext.Cafes
                .Where(c => c.CafeId == id)
                .Include(c => c.Reviews)
                .FirstOrDefault();

            if ( cafe == null)
            {
                // Could not find the cafe
            }
            else
            {
                Review review = new Review();

                review.CafeId = id;
                review.Cafe = cafe;
                review.ReviewDate = DateTime.Now;
                review.ReviewerName = model.ReviewerName;
                review.Rating = model.Rating;
                review.Comments = model.Comments;

                if (model.Comments != null)
                {
                    var response = _textAnalyticsClient.AnalyzeSentiment(model.Comments);
                    review.CommentsSentiment = response.Value.Sentiment.ToString();
                }


                if ( model.ReviewPhoto != null )
                {                   
                    using (Stream stream = model.ReviewPhoto.OpenReadStream())
                    {
                        using (MemoryStream ms = new MemoryStream())
                        {
                            stream.CopyTo(ms);
                            ms.Position = 0;

                            var blobGuid = Guid.NewGuid();
                            _blobContainerClient.UploadBlob(blobGuid.ToString() +".jpg", ms);

                            ms.Position = 0;
                            using (var thumbnailStream = this.CreateThumbnailImage(ms) )
                            {
                                var thumbnailName = $"{blobGuid.ToString()}-thumbnail.jpg";
                                _blobContainerClient.UploadBlob(thumbnailName, thumbnailStream);
                            }

                            review.ReviewPhotoName = blobGuid.ToString();
                        }
                    }
                }

                cafe.Reviews.Add(review);
                _cafeContext.SaveChanges();                    
            }

            return RedirectToAction("Details", new { id = id });
        }



        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }



        private MemoryStream CreateThumbnailImage(MemoryStream reviewPhoto)
        {
            using (Image image = Image.Load(reviewPhoto))
            {
                int width = 100;
                int height = 0;  // Will automatically set to maintain aspect ratio
                image.Mutate(x => x.Resize(width, height));

                MemoryStream thumbnailStream = new MemoryStream();
                image.SaveAsJpeg(thumbnailStream);

                thumbnailStream.Position = 0;

                return thumbnailStream;
            }
        }



    }
}