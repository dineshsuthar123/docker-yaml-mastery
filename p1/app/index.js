const http = require("http");

const PORT = 3000;
const MONGO_URL = process.env.MONGO_URL;

http.createServer((req, res) => {
    res.writeHead(200);
    res.end(`Hello from Node! Connected to ${MONGO_URL}`);
}).listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
