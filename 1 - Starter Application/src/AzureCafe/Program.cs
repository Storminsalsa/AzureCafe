using Azure;
using Azure.AI.TextAnalytics;
using Azure.Storage.Blobs;
using AzureCafe.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("AzureCafeConnectionString");
builder.Services.AddDbContext<AzureCafeContext>(options =>
    options.UseSqlServer(connectionString));

var storageConnectionString = builder.Configuration.GetConnectionString("StorageConnectionString");
//BlobServiceClient
BlobContainerClient blobContainerClient = new BlobContainerClient(storageConnectionString, "review-photos");
builder.Services.AddSingleton<BlobContainerClient>(blobContainerClient);

var textAnalyticsKey = builder.Configuration["TextAnalyticsKey"];
var textAnalyticsUrl = builder.Configuration["TextAnalyticsUrl"];
TextAnalyticsClient textAnalyticsClient = new TextAnalyticsClient(new Uri(textAnalyticsUrl), new AzureKeyCredential(textAnalyticsKey));
builder.Services.AddSingleton<TextAnalyticsClient>(textAnalyticsClient);

builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
