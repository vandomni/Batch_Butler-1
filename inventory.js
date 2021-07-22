module.exports = function(){
  var express = require('express');
  var router = express.Router();


  function getIngredientsInventory(res, mysql, context, complete){
    mysql.pool.query("SELECT ingredient_id as id, ingredient_name FROM ingredient", function(error, results, fields){
      if(error){
        res.write(JSON.stringify(error));
        res.end();
      }
      context.ingredient = results;
      complete();
    });
  }
  
  function getInventory(res, mysql, context, complete){
    mysql.pool.query("SELECT ingredient_name as ingredient_name, amount as amount, amount_type as type from Bakery_inventory_v3;", function(error, results, fields){
      if(error){
        res.write(JSON.stringify(error));
        res.end();
      }
      context.inventory = results;
      complete();
    });
  }
  
  router.get('/', function(req, res){
    var callbackCount = 0;
    var context = {};
	context.jsscripts = ["deleteinventory.js"];
    var mysql = req.app.get('mysql');
    getInventory(res, mysql, context, complete);
	getIngredientsInventory(res, mysql, context, complete);
    function complete(){
      callbackCount++;
      if(callbackCount >= 2){
        res.render('inventory', context);
      }
    }
  });
  
  router.post('/', function(req, res){
	  console.log(req.body)
	  var mysql = req.app.get('mysql');
	  var sql = "INSERT INTO inventory (location, ingredient, amount) VALUES (?, ?, ?)";
	  var  inserts = [req.body.location, req.body.ingredient, req.body.amount];
	  sql = mysql.pool.query(sql, inserts,function(error, results, fields){
		  if(error){
			  console.log(JSON.stringify(error))
			  res.write(JSON.stringify(error));
			  res.end();
		  }else{
			  res.redirect('/inventory');
		  }
	  });
  });
  
  router.delete('/:id', function(req,res){
	  var mysql = req.app.get('mysql');
	  var sql = "DELETE FROM inventory WHERE ingredient = ?";
	  var inserts = [req.params.id];
	  sql = mysql.pool.query(sql, inserts, function(error, results, fields){
		  if(error){
			  console.log(error)
			  res.write(JSON.stringify(error));
			  res.status(400);
			  res.end();
		  }else{
			  res.status(202).end();
		  }
	  })
  })
  
  return router;
}();
