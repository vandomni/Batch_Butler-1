module.exports = function(){
  var express = require('express');
  var router = express.Router();
  
  function getVendors(res, mysql, context, complete) {
	  mysql.pool.query("SELECT vendor_id as id, vendor_name, location FROM vendor;", function(error, results, fields){
		  if(error){
			  res.write(JSON.stringify(error));
			  res.end();
		  }
		  context.vendor_inventory = results;
		  complete();
	  });
  }
  
  /* gets a single vendor to view their inventory */
  function getVendor(res, mysql, context, id, complete){
	  var sql = "SELECT vendor_id as id, vendor_name, location FROM vendor WHERE vendor_id = ?";
	  var inserts = [id];
	  mysql.pool.query(sql, inserts, function(error, results, fields){
		  if(error){
			  res.write(JSON.stringify(error));
			  res.end();
		  }
		  context.view_inventory = results[0];
		  complete();
	  });
  }
  
  /* displays the different vendors in the database */
  router.get('/', function(req, res){
	  var callbackCount = 0;
	  var context = {};
	  var mysql = req.app.get('mysql');
	  getVendors(res, mysql, context, complete);
	  function complete(){
		  callbackCount++;
		  if(callbackCount >= 1){
			  res.render('vendor_inventory', context);
		  }
	  }
  });
  
  /* displays one vendor for the purpose of viewing their inventory and updating it */
  router.get('/:id', function(req, res){
	  callbackCount = 0;
	  var context = {};
	  context.jsscripts = ["vendor.js"];
	  var mysql = req.app.get('mysql');
	  getVendor(res, mysql, context, req.params.id, complete);
	  function complete(){
		  callbackCount++;
		  if(callbackCount >= 1){
			  res.render('view_inventory', context);
		  }
	  }
  });
  
	return router;
}();