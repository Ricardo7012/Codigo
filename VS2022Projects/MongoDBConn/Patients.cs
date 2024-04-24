using MongoDB.Bson;

namespace PatientDataRetrieval
{
    // Define a class to represent patient data
    public class Patients
    {
        public ObjectId _id { get; set; }
        public string? MemberNumber { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Gender { get; set; }
        //public string? Addresses { get; set; }
        // Add more properties as needed
    }
}

