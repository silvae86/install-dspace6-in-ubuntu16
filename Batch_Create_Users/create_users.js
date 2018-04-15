var XLSX = require("xlsx");
var file = XLSX.readFile("userdata.xlsx");
var sheet = file.Sheets["Sheet1"]
var students = XLSX.utils.sheet_to_json(sheet, {header:0})
var child_process = require("child_process");

var dspaceExecutablePath = "/dspace/dspace/bin/dspace"

// console.log(JSON.stringify(students, null, 4));

for(var i = 0; i < students.length; i++)
{
	var student = students[i];
	var email = student["Email"];
	var firstName = student["Primeiro"];
	var lastName = student["Ultimo"];
	
	var command = `${dspaceExecutablePath} user --add --email "${email}" --givenname "${firstName}" --surname "${lastName}" --password "rebucadosHALLS"`
	console.log(command)
	
	child_process.execSync(command);
}
