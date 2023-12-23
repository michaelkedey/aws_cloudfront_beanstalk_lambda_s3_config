using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Amazon.Lambda;
using Amazon.Lambda.Model;
using System.Text;
using Newtonsoft.Json;
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
        public IActionResult SaveName(string name)
        {
            string lambdaFunctionName = System.Environment.GetEnvironmentVariable("LAMBDA_FUNCTION_NAME"); // Replace with your Lambda function name
            string awsRegion = System.Environment.GetEnvironmentVariable("AWS_REGION"); // Replace with your AWS region

            var formData = new { name = name };
            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(formData);

            using (var lambdaClient = new AmazonLambdaClient(Amazon.RegionEndpoint.GetBySystemName(awsRegion)))
            {
                var invokeRequest = new InvokeRequest
                {
                    FunctionName = lambdaFunctionName,
                    InvocationType = InvocationType.RequestResponse,
                    Payload = jsonData
                };

                var invokeResponse = lambdaClient.InvokeAsync(invokeRequest).Result;

                if (invokeResponse.StatusCode == 200)
                {
                    var responseJson = Encoding.UTF8.GetString(invokeResponse.Payload.ToArray());
                    ViewBag.Message = $"Lambda response: {responseJson}";
                }
                else
                {
                    ViewBag.Message = $"Error invoking Lambda function: {invokeResponse.StatusCode} - {invokeResponse.StatusDescription}";
                }
            }

            return View("Index");
        }
    }
}

















// using System.Environment;
// using Microsoft.AspNetCore.Builder;
// using Microsoft.AspNetCore.Hosting;
// using Microsoft.AspNetCore.Http;
// using Microsoft.Extensions.DependencyInjection;
// using Amazon.Lambda;
// using Amazon.Lambda.Model;
// using System.Text;
// using Newtonsoft.Json;
// using Microsoft.AspNetCore.Mvc;

// namespace LambdaWebApp.Controllers
// {
//     public class HomeController : Controller
//     {
//         public IActionResult Index()
//         {
//             return View();
//         }

//         [HttpPost]
//         public IActionResult SaveName(string name)
//         {
//             string lambdaFunctionName = System.Environment.GetEnvironmentVariable("LAMBDA_FUNCTION_NAME"); // Replace with your Lambda function name
//             string awsRegion = System.Environment.GetEnvironmentVariable("AWS_REGION"); // Replace with your AWS region

//             var formData = new { name = name };
//             string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(formData);

//             using (var lambdaClient = new AmazonLambdaClient(Amazon.RegionEndpoint.GetBySystemName(awsRegion)))
//             {
//                 var invokeRequest = new InvokeRequest
//                 {
//                     FunctionName = lambdaFunctionName,
//                     InvocationType = InvocationType.RequestResponse,
//                     Payload = jsonData
//                 };

//                 var invokeResponse = lambdaClient.InvokeAsync(invokeRequest).Result;

//                 if (invokeResponse.StatusCode == 200)
//                 {
//                     var responseJson = Encoding.UTF8.GetString(invokeResponse.Payload.ToArray());
//                     ViewBag.Message = $"Lambda response: {responseJson}";
//                 }
//                 else
//                 {
//                     ViewBag.Message = $"Error invoking Lambda function: {invokeResponse.StatusCode} - {invokeResponse.StatusDescription}";
//                 }
//             }

//             return View("Index");
//         }
//     }
// }
