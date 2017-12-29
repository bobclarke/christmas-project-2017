var express = require('express');
var app = express();
var port = process.env.PORT || 8080;
var colour = process.env.COLOUR;
var router = express.Router();

router.get('/', function(req, res) {
  res.json({'colour': colour});
});

app.use('/', router);

app.listen(port);

console.log('Server started on :' + port);
