var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : 'cs340_vandomni',
  password        : '6394',
  database        : 'cs340_vandomni'
});
module.exports.pool = pool;
