function searchIngredientsByName() {
	var ingredient_name_string = document.getElementById('ingredient_name_string').value
	window.location = '/ingredients/search/' + encodeURI(ingredient_name_string)
}