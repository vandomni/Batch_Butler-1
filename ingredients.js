module.exports = function(){
  var express = require('express');
  var router = express.Router();

  function getIngredients(res, mysql, context, complete){
    mysql.pool.query("SELECT ingredient_id as id, ingredient_name, ingredient_type, amount_type FROM ingredient;", function(error, results, fields){
      if(error){
        res.write(JSON.stringify(error));
        res.end();
      }
      context.ingredients = results;
      complete();
    });
  }
  /* find ingredient name that starts with a given string */
  function getIngredientsWithNameLike(req, res, mysql, context, complete) {
	  var query = "SELECT ingredient.ingredient_id as id, ingredient_name, ingredient_type, amount_type FROM ingredient WHERE ingredient_name LIKE" + mysql.pool.escape(req.params.s + '%');
	  console.log(query)
	  
	  mysql.pool.query(query, function(error, results, fields){
		  if(error){
			  res.write(JSON.stringify(error));
			  res.end();
		  }
		  context.ingredients = results;
		  complete();
	  });
  }
  /* gets a single individual to read the data from */
  function getIngredient(res, mysql, context, id, complete){
	  var sql = "SELECT ingredient_id as id, ingredient_name, ingredient_type, amount_type FROM ingredient WHERE ingredient_id = ?";
	  var inserts = [id];
	  mysql.pool.query(sql, inserts, function(error, results, fields){
		  if(error){
			  res.write(JSON.stringify(error));
			  res.end();
		  }
		  context.ingredient = results[0];
		  complete();
	  });
  }
  
  /*displays all of the ingredients in the database */
  router.get('/', function(req, res){
    var callbackCount = 0;
    var context = {};
	context.jsscripts = ["deleteingredient.js", "searchingredients.js"];
    var mysql = req.app.get('mysql');
    getIngredients(res, mysql, context, complete);
    function complete(){
      callbackCount++;
      if(callbackCount >= 1){
        res.render('ingredients', context);
      }
    }
  });
  
  
  /* Display all ingredients that start with a given string */
  router.get('/search/:s', function(req, res){
	  var callbackCount = 0;
	  var context = {};
	  context.jsscripts = ["deleteingredient.js", "searchingredients.js"];
	  var mysql = req.app.get('mysql');
	  getIngredientsWithNameLike(req, res, mysql, context, complete);
	  function complete(){
		  callbackCount++;
		  if(callbackCount >=1){
			res.render('ingredients', context);
		  }
	  }
  });
  /* displays one ingredient for the purpose of updating an ingredient */
  
  router.get('/:id', function(req, res){
	  callbackCount = 0;
	  var context = {};
	  context.jsscripts = ["updateingredient.js"];
	  var mysql = req.app.get('mysql');
	  getIngredient(res, mysql, context, req.params.id, complete);
	  function complete(){
		callbackCount++;
		if(callbackCount >= 1){
			res.render('update-ingredient', context);
		}
	  }
  });
		
  router.post('/', function(req,res){
	console.log(req.body)
	var mysql = req.app.get('mysql');
	var sql = "INSERT INTO ingredient (ingredient_name, ingredient_type, amount_type) VALUES (?,?,?)";
	var inserts = [req.body.ingredient_name, req.body.ingredient_type, req.body.amount_type];
	sql = mysql.pool.query(sql,inserts,function(error, results, fields){
		if(error){
			console.log(JSON.stringify(error))
			res.write(JSON.stringify(error));
			res.end();
		}else{
			res.redirect('/ingredients');
		}
	});
  });
  
  router.put('/:id', function(req, res){
	  var mysql = req.app.get('mysql');
	  console.log(req.body)
	  console.log(req.params.id)
	  var sql = "UPDATE ingredient SET ingredient_name=?, ingredient_type=?, amount_type=? WHERE ingredient_id=?";
	  var inserts = [req.body.ingredient_name, req.body.ingredient_type, req.body.amount_type, req.params.id];
	  sql = mysql.pool.query(sql, inserts, function(error, results, fields){
		  if(error){
			  console.log(error)
			  res.write(JSON.stringify(error));
			  res.end();
		  }else{
			  res.status(200);
			  res.end();
		  }
	  });
  });
  
  router.delete('/:id', function(req,res){
	  var mysql = req.app.get('mysql');
	  var sql = "DELETE FROM ingredient WHERE ingredient_id = ?";
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
	  });
  
  return router;
}();