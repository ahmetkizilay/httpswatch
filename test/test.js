const handler = require('../lambda').myHandler;


handler(null, null, function (filename) {
  console.log(filename);
});