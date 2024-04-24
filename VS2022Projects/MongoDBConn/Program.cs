//using System;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json;

namespace PatientDataRetrieval
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // Build configuration
                IConfiguration configuration = new ConfigurationBuilder()
                    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                    .Build();

                // Get MongoDB configuration
                var mongoDBConfig = configuration.GetSection("MongoDB");
                string connectionString = mongoDBConfig["ConnectionString"]!;
                string databaseName = mongoDBConfig["DatabaseName"]!;
                string collectionName = mongoDBConfig["CollectionName"]!;

                // Prompt user to enter patient ID
                Console.WriteLine("Enter the patient ID:");
                // Patient _id you want to retrieve
                string patientIdInput = Console.ReadLine()!;

                ObjectId patientId;
                if (!ObjectId.TryParse(patientIdInput, out patientId))
                {
                    Console.WriteLine("Invalid patient ID format.");
                    return;
                }

                // Connect to MongoDB
                MongoClient client = new MongoClient(connectionString);
                IMongoDatabase database = client.GetDatabase(databaseName);
                IMongoCollection<BsonDocument> collection = database.GetCollection<BsonDocument>(collectionName);

                // Define filter
                var filter = Builders<BsonDocument>.Filter.Eq("_id", ObjectId.Parse(patientIdInput));

                // Retrieve patient data
                var patientBson = collection.Find(filter).FirstOrDefault();

                if (patientBson != null)
                {
                    // Convert BsonDocument to Patient object
                    var patient = new Patients
                    {
                        _id = patientBson["_id"].AsObjectId,
                        MemberNumber = patientBson["MemberNumber"].AsString,
                        FirstName = patientBson["FirstName"].AsString,
                        LastName = patientBson["LastName"].AsString,
                        Gender = patientBson["Gender"].AsString,
                        // TO DO: ADD ARRAY LOGIC -
                        // TO DO: IMPLEMENT REVERSE POGO GENERATOR 
                        // Addresses = patientBson["Addresses"].AsString,
                        // Add more properties as needed
                    };

                    // Serialize patient data to JSON
                    string json = JsonConvert.SerializeObject(patient, Formatting.Indented);
                    Console.WriteLine(json);
                }
                else
                {
                    Console.WriteLine("Patient not found.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("An error occurred: " + ex.Message);
            }
        }
    }
}