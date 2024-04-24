
// jdbc:mongodb://pdatamasking_ro:tBpkfgvZGl3n2XIugO4P@172.18.205.50:28510/Member
// pvmongodpx01.iehp.org
// https://www.mongodb.com/docs/drivers/csharp/current/
// https://www.nuget.org/packages/MongoDB.Driver



using MongoDB.Driver;

internal class Program
{
    private static void Main(string[] args)
    {
        var connectionString = "mongodb://pdatamasking_ro:tBpkfgvZGl3n2XIugO4P@172.18.205.50:28510";
        var client = new MongoClient(connectionString);

        // db.getCollection("Member").find({})
        var filter = Builders<BsonDocument>.Filter.Eq("MemberNumber", "19961000155000");
        var result = collection.Find(filter).ToList();


        global::System.Object value = client.Dispose();
    }
}