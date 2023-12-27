// File: HomeController.cs

using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace LambdaWebApp.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> SaveName(string name)
        {
            string lambdaApiUrl = "https://5n5el56ybl.execute-api.us-east-1.amazonaws.com/prod"; // Replace with your Lambda API Gateway URL

            var formData = new { Name = name };
            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(formData);

            using (var httpClient = new HttpClient())
            {
                var content = new StringContent(jsonData, Encoding.UTF8, "application/json");
                var response = await httpClient.PostAsync(lambdaApiUrl, content);

                if (response.IsSuccessStatusCode)
                {
                    var responseJson = await response.Content.ReadAsStringAsync();
                    ViewBag.Message = $"Lambda response: {responseJson}";
                }
                else
                {
                    ViewBag.Message = $"Error: {response.StatusCode} - {response.ReasonPhrase}";
                }
            }

            return View("Index");
        }
    }
}
