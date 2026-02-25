const http = require("http");
http.createServer((req, res) => {
  res.writeHead(200);
  res.end("Dodo Payments Backend V1 Active");
}).listen(8080);
console.log("Server running on port 8080");
