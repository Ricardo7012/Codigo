
# Studio3T - LogDataLocation
```bash
cls
db.getLogComponents()

db.getSiblingDB("admin").runCommand({getCmdLineOpts: 1});

db.adminCommand({getLog: 'global'})

db.adminCommand( { getLog:'global'} ).log.forEach(x => {print(x)})

// /mnt/provision/newsource/vdb_mount/logs/dlpx.s0m0.28510.mongod.log
// https://www.mongodb.com/docs/manual/reference/log-messages/
// https://blog.devgenius.io/a-comprehensive-mongodb-command-guide-for-everyday-use-757b8bc06095
// https://www.mongodb.com/docs/v5.3/tutorial/use-database-commands/


## * - Returns a list of the available values to the 
## global - Returns the combined output of all recent log entries.
## startupWarnings - Returns log entries that may contain errors or warnings from MongoDB's log from when the current process started. If mongod started without warnings, this filter may return an empty array.


--https://www.mongodb.com/docs/manual/reference/command/getLog/
cls
db.getSiblingDB("admin").runCommand({getCmdLineOpts: 1})

db.adminCommand({ getLog:'global'})
db.adminCommand({ getLog:'global' }).log.filter(entry => entry.includes('NETWORK')).forEach(entry => print(entry));

db.adminCommand({ getLog: "*" })

db.adminCommand({ getLog:'global'}).log.forEach(x => {print(x)})

const execSync = require("child_process").execSync;
const result = execSync("find / -name 'mongod.log'").toString();
print(result);

db.adminCommand({getLog: 1})
db.runCommand({ serverStatus: 1}).metrics
db.runCommand({ serverStatus: 1}).metrics.commands
db.runCommand({ serverStatus: 1}).metrics.commands.update

db.runCommand( { serverStatus: 1, repl: 0, metrics: 0, locks: 0 } )

db.runCommand( { serverStatus: 1, metrics: { query: { multiPlanner: { histograms: false } } } } )

db.serverStatus()
cls;
use admin;
db.runCommand({top: 1 });


--https://www.mongodb.com/docs/manual/reference/command/buildInfo/
## // HOSTBUILDINFO #######################################
cls;
use admin;

db.adminCommand({hostInfo: 1 });

db.runCommand({buildInfo: 1 });


## // HEALTH CHECK #######################################
cls;
use admin;
//LOOK FOR ok: 1,
// https://www.mongodb.com/basics/how-to-monitor-mongodb-and-what-metrics-to-monitor
// https://ittutorial.org/mongodb-healthcheck-step-by-step/
db.runCommand("ping").ok;
db.stats().ok;
rs.status().ok;
db.serverStatus().ok;
db.runCommand({dbStats: 1}).ok;
db.runCommand({top: 1 }).ok;
db.adminCommand({ getLog: "*" }).ok;
//db.adminCommand({ getLog:'global'})
//db.adminCommand({ getLog:'global'}).log.forEach(x => {print(x)})
//db.adminCommand({ getLog:'global' }).log.filter(entry => entry.includes('NETWORK')).forEach(entry => print(entry));
db.getSiblingDB("admin").runCommand({getCmdLineOpts: 1})
## // LOGDATALOCATION #######################################
cls
db.getSiblingDB("admin").runCommand({getCmdLineOpts: 1})

// Get current date
var today = new Date();

// Set hours, minutes, seconds, and milliseconds to 0 to get midnight
today.setHours(0, 0, 0, 0);

// Add one day to get the start of tomorrow
var tomorrow = new Date(today);
tomorrow.setDate(today.getDate() + 1);

// Log the dates to verify
console.log("Today: " + today);
console.log("Tomorrow: " + tomorrow);

// Retrieve log entries for today
db.adminCommand({
  getLog: 'global',
  from: today,
  to: tomorrow
}).log.forEach(x => { 
  print(x); 
});


// Retrieve the last 101 log entries
db.adminCommand({
  getLog: 'global',
  n: 101
}).log.forEach(x => { 
  print(x); 
});
```