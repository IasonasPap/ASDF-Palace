const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const app = express();

app.use(cors());

// to support JSON-encoded bodies
app.use(bodyParser.json());

// to support URL-encoded bodies
app.use(bodyParser.urlencoded({ extended: true }));


const routes = require('./endpoints');
app.use('/asdfpalace',routes);

// set port, listen for requests
const PORT = 5000;

// Create an HTTP service.
//http.createServer(app).listen(8766);

if (process.env.NODE_ENV != 'test'){
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}.`);
    });
}

module.exports = app;
