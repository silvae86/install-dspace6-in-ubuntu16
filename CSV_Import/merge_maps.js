var fs = require("fs");
var readline = require("readline");
var async = require('async');
var glob = require('glob');
var zpad = require("zpad");

var destinationMapFile = "map";

var readlines = function(file, callback)
{
  var lines = [];

  var lineReader = readline.createInterface({
    input: require('fs').createReadStream(file)
  });

  lineReader.on('line', function (line) {
    lines.push(line);
  });

  lineReader.on('close', function () {
    // console.log("File " + file + " : \n" + lines);
    callback(null, {
      file: file,
      lines: lines
    });
  })

  lineReader.on('error', function () {
    callback(1);
  })
}
try{
  fs.unlinkSync(destinationMapFile);
}
catch(e)
{
  // console.log("No existing map found, no need to delete.");
}

var stream = fs.createWriteStream(destinationMapFile, {flags:'a'});

glob("maps/map_import_*", function (er, files) {
  if(!er)
  {
    var counter = 1;
    var concatenatedMap = [];
    async.mapSeries(files, readlines, function(err, allLinesByFile){
      for (var i = 0; i < allLinesByFile.length; i++) {
        var lines = allLinesByFile[i].lines;
        //console.log("LINES" + lines);
        lines.forEach(
          function(item, index)
          {
            var itemId = item.substr(item.indexOf(" ") + 1);
            var modifiedLine = zpad(counter,5) + " " + itemId;
            concatenatedMap.push(modifiedLine);
            counter++;
          }
        );
      }
      concatenatedMap.forEach(function (item,index) {
          stream.write(item + "\n");
      });

      stream.end();
    });
  }
  else
  {
    throw new Error(err);
  }
})
