-- table creation for Batch butler --

CREATE TABLE shift_lead(
	shift_id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	shift_name VARCHAR(255) NOT NULL,
	shift_password VARCHAR(255) NOT NULL,
	start_date DATE	NOT NULL

);

CREATE TABLE recipe(
	recipe_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	recipe_name VARCHAR(255) NOT NULL,
	quantity INT NOT NULL,
	recipe_type VARCHAR(255) NOT NULL
);

CREATE TABLE ingredient(
	ingredient_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ingredient_name VARCHAR(255) NOT NULL,
	ingredient_type VARCHAR(255) NOT NULL,
	amount_type VARCHAR(255) NOT NULL
);

CREATE TABLE Ingredient_list (
	rid INT,
	iid INT,
	amount_needed INT NOT NULL,
	FOREIGN KEY (rid) REFERENCES recipe(recipe_id),
	FOREIGN KEY (iid) REFERENCES ingredient(ingredient_id),
	PRIMARY KEY (rid, iid)
);

CREATE TABLE produces (
	sid INT,
	rid INT,
	made_on DATE NOT NULL,
	batch_multiplier INT NOT NULL,
	FOREIGN KEY (rid) REFERENCES recipe(recipe_id),
	FOREIGN KEY (sid) REFERENCES shift_lead(shift_id),
	PRIMARY KEY (sid, rid, made_on, batch_multiplier)
);

CREATE TABLE pastry_case (
	daily_pastry_case DATE NOT NULL,
	rid INT,
	sid INT,
	amount INT NOT NULL,
	FOREIGN KEY (rid) REFERENCES recipe(recipe_id),
	FOREIGN KEY (sid) REFERENCES shift_lead(shift_id),
	PRIMARY KEY (daily_pastry_case, rid)
);


CREATE TABLE inventory (
	location VARCHAR(255) NOT NULL,
	ingredient INT,
	amount INT,
	FOREIGN KEY (ingredient) REFERENCES ingredient(ingredient_id),
	PRIMARY KEY (location, ingredient)
);

CREATE TABLE shipment (
	shipment_id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ship_date DATE NOT NULL
);

CREATE TABLE shipment_contents (
	shid INT,
	ingredient INT,
	amount INT,
	FOREIGN KEY (shid) REFERENCES shipment(shipment_id),
	FOREIGN KEY (ingredient) REFERENCES ingredient(ingredient_id)
);

CREATE TABLE vendor (
	vendor_id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	vendor_name VARCHAR(255) NOT NULL,
	location VARCHAR(255),
	FOREIGN KEY (location) REFERENCES inventory(location)
);

CREATE TABLE ships(
	vid INT(11),
	shid INT(11),
	FOREIGN KEY (vid) REFERENCES vendor(vendor_id),
	FOREIGN KEY (shid) REFERENCES shipment(shipment_id),
	PRIMARY KEy(vid, shid)
);

INSERT INTO ingredient ( ingredient_name, ingredient_type, amount_type)
VALUES ('Chip, Chocolate', 'Dry', 'lb'),
('Flour, Hi-Gluten', 'Dry', 'lb'),
('Egg product', 'Wet', 'lb'),
('Sugar, Cane', 'Dry', 'lb'),
('Flour, Lo-Gluten', 'Dry', 'lb'),
('Flour, Pastry', 'Dry', 'lb'),
('Sugar, Brown', 'Dry', 'lb'),
('Sugar, Confectioners', 'Dry', 'lb'),
('Eggs, Large', 'Wet', 'Qty'),
('Butter, Block', 'Chilled', 'lb'),
('Butter, 1 Lb.', 'Chilled', 'lb'),
('Vanilla, Extract', 'Wet', 'Oz'),
('Vanilla, Bean', 'Dry', 'Qty'),
('Milk, Whole', 'Chilled', 'Oz'),
('Coffee, Bean', 'Dry', 'lb')
;

INSERT INTO recipe (recipe_name, quantity, recipe_type)
VALUES ('Test Cookie', 200, 'Cookie'),
('Test Muffin', 200, 'Muffin'),
('Test Cake', 10, 'Cake'),
('Chocolate Chip', 200, 'Cookie'),
('Ginger Molasses', 200, 'Cookie'),
('Peanut Butter', 200, 'Cookie'),
('Oatmeal Raisin', 200, 'Cookie'),
('Chocolate Cake', 15, 'Cake'),
('White Cake', 15, 'Cake'),
('Donut Muffin', 200, 'Muffin'),
('Cranberry Shortcake', 20, 'Shortcake')
;

INSERT INTO Ingredient_list ( rid, iid, amount_needed)
VALUES
/*
Insert test cookie with recpie 'Test Cookie'
Ingredients chocolate chip, egg product, sugar(cane and brown), butter, vanilla extract
*/
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cookie'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Chip, Chocolate'),20
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cookie'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Egg product'),10
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cookie'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Sugar, Cane'),20
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cookie'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Sugar, Brown'),20
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cookie'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Butter, Block'),15
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cookie'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Vanilla, Extract'),2
),
/*
insert test muffin with recipe 'Test Muffin'
ingredients sugar, milk, butter, flour high gluten, vanilla extract
*/
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Muffin'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Sugar, Cane'),10
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Muffin'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Milk, Whole'),15
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Muffin'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Butter, Block'),10
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Muffin'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Flour, Hi-Gluten'),25
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Muffin'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Vanilla, Extract'),1
),
/*
insert test cake with recipe 'Test Cake'
ingredients 'flour pastry' sugar, milk, chocolate chips, egg product, coffee,
*/
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cake'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Flour, Pastry'), 20
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cake'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Sugar, Cane'), 10
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cake'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Milk, Whole'), 20
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cake'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Chip, Chocolate'), 15
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cake'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Egg product'), 10
),
(
	( SELECT recipe_id FROM recipe WHERE recipe_name = 'Test Cake'),
	( SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Coffee, Bean'), 10
);




INSERT INTO inventory (location, ingredient, amount)
VALUES
('Bakery', 1, 200),
('Bakery', 2, 200),
('Bakery', 3, 200),
('Bakery', 4, 200),
('Bakery', 5, 200),
('Bakery', 6, 200),
('Bakery', 7, 200),
('Bakery', 8, 200),
('Bakery', 9, 200),
('Bakery', 10, 200),
('Bakery', 11, 200),
('Bakery', 12, 200),
('Bakery', 13, 200),
('Bakery', 14, 200),
('Meat Avenue', 3, 2000),
('Butter Avenue', 10, 2000 ),
('Butter Avenue', 11, 2000),
('Sweetooth lane', 4, 2000),
('Sweetooth lane', 7, 2000)
;

INSERT INTO shift_lead (shift_name, shift_password, start_date)
VALUES ('Mark', 'Mark_R0X', '2020-02-02'),
('Sharol', '1234', '2020-02-02')
;

INSERT INTO vendor (vendor_name, location)
VALUES ('MEAT AND STUFF', 'Meat Avenue'),
('Butter and things', 'Butter Avenue'),
('Sweet Stuff', 'Sweetooth lane');

INSERT INTO shipment (ship_date)
VALUES ('2020-01-01'),
('2020-01-15'),
('2020-01-15');

INSERT INTO shipment_contents (shid, ingredient, amount)
VALUES ((SELECT shipment_id FROM shipment WHERE shipment_id = 1),(SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Egg product'), 200),
((SELECT shipment_id FROM shipment WHERE shipment_id = 2),(SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Butter, Block'), 200),
((SELECT shipment_id FROM shipment WHERE shipment_id = 3),(SELECT ingredient_id FROM ingredient WHERE ingredient_name = 'Sugar, Cane'), 200);

INSERT INTO ships (vid, shid)
VALUES ((SELECT vendor_id FROM vendor WHERE vendor_name = 'MEAT AND STUFF'),(SELECT shipment_id FROM shipment WHERE shipment_id = 1)),
((SELECT vendor_id FROM vendor WHERE vendor_name = 'Butter and things'),(SELECT shipment_id FROM shipment WHERE shipment_id = 2)),
((SELECT vendor_id FROM vendor WHERE vendor_name = 'Sweet Stuff'),(SELECT shipment_id FROM shipment WHERE shipment_id = 3));

INSERT INTO pastry_case (daily_pastry_case, rid, sid, amount)
VALUES ('2020-05-12', (SELECT recipe_id FROM recipe WHERE recipe_name = 'Chocolate Chip'), (SELECT shift_id FROM shift_lead WHERE shift_name = 'Mark'), 50),
('2020-05-13', (SELECT recipe_id FROM recipe WHERE recipe_name = 'White Cake'), (SELECT shift_id FROM shift_lead WHERE shift_name = 'Sharol'), 10);

--MISSING insert statements produces--

--Querys for data below --


--Use the following to grab ingredient from a location --

--Bakery inventory--
SELECT ingredient.ingredient_name, inventory.amount FROM ingredient, inventory WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Bakery';

--MEAT AND STUFF inventory--
SELECT ingredient.ingredient_name, inventory.amount  FROM ingredient, inventory WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Meat Avenue';

--Butter and things inventory--
SELECT ingredient.ingredient_name, inventory.amount FROM ingredient, inventory WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Butter Avenue';

--Sweet Stuff inventory--
SELECT ingredient.ingredient_name, inventory.amount FROM ingredient, inventory WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Sweetooth lane';

--Selecting the ingredients involved in a recipe--

--Test cookie recipe list --
SELECT recipe.recipe_name, ingredient.ingredient_name, Ingredient_list.amount_needed FROM recipe, ingredient, Ingredient_list WHERE ingredient.ingredient_id = Ingredient_list.iid AND Ingredient_list.rid = recipe.recipe_id AND recipe.recipe_name = 'Test Cookie';

--Test Muffin recipe list --
SELECT recipe.recipe_name, ingredient.ingredient_name, Ingredient_list.amount_needed FROM recipe, ingredient, Ingredient_list WHERE ingredient.ingredient_id = Ingredient_list.iid AND Ingredient_list.rid = recipe.recipe_id AND recipe.recipe_name = 'Test Muffin';

--Test Muffin recipe list --
SELECT recipe.recipe_name, ingredient.ingredient_name, Ingredient_list.amount_needed FROM recipe, ingredient, Ingredient_list WHERE ingredient.ingredient_id = Ingredient_list.iid AND Ingredient_list.rid = recipe.recipe_id AND recipe.recipe_name = 'Test Cake';

--UPDATE queries for changing inventory amounts after creating a recipe --

/*UPDATE inventory SET amount =
(SELECT inventory.amount
FROM inventory, ingredient
WHERE ingredient.ingredient_id = inventory.ingredient
MINUS
SELECT Ingredient_list.amount_needed
FROM Ingredient_list
WHERE Ingredient_list.iid = inventory.ingredient AND Ingredient_list.rid = 1; );*/


--Triggers for the bakery inventory --

--Trigger to delete the contents of a shipment once they have been delivered--

DELIMITER //

CREATE TRIGGER delete_shipment
BEFORE DELETE ON shipment_contents FOR EACH ROW
BEGIN
	DELETE FROM shipment_contents WHERE OLD.shipment_contents.shipment_id = shipment_contents.shipment_id;
END
//

DELIMITER ;

/******************************************************************************

--Views for looking at Batch Butler --
--Still need to add pastry case, shipment contents, shipments, vendors, ingredients.

******************************************************************************/

--Accessing the recipes available at the bakery--
--Use command "SELECT * FROM Bakery_recipes;"
CREATE VIEW Bakery_recipes AS
SELECT recipe_id, recipe_name
FROM recipe
ORDER BY recipe_name;



--Accessing the inventory available at the bakery--
--Use command "SELECT * FROM Bakery_inventory;"
CREATE VIEW Bakery_inventory AS
SELECT ingredient.ingredient_name, inventory.amount
FROM ingredient, inventory
WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Bakery'
ORDER BY ingredient.ingredient_name;

--Accessing the inventory available at the MEAT and STUFF --
--Use command "SELECT * FROM Meat_Avenue_inventory"
CREATE VIEW Meat_Avenue_inventory AS
SELECT ingredient.ingredient_name, inventory.amount
FROM ingredient, inventory
WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Meat Avenue'
ORDER BY ingredient.ingredient_name;

--Accessing the inventory available at the Sweetooth --
--Use command "SELECT * FROM Sweetooth_inventory"
CREATE VIEW Sweetooth_inventory AS
SELECT ingredient.ingredient_name, inventory.amount
FROM ingredient, inventory
WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Sweetooth lane'
ORDER BY ingredient.ingredient_name;

--Accessing the inventory available at the Sweetooth --
--Use command "SELECT * FROM Butter_and_things_inventory"
CREATE VIEW Butter_and_things_inventory AS
SELECT ingredient.ingredient_name, inventory.amount
FROM ingredient, inventory
WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Butter Avenue'
ORDER BY ingredient.ingredient_name;


/*
SELECT recipe.recipe_name FROM recipe, produces WHERE recipe.recipe_id = produces.rid AND produces.made_on = todays date

SELECT shipment.shipment_id FROM shipment WHERE ship_date = todays date

SELECT shipment.shipment_id FROM shipment WHERE ship_date = yesterdays date

SELECT recipe.recipe_name FROM recipe

GROUP BY ingredient_type;

DELETE FROM production WHERE rid = '$deletedID'

*/
