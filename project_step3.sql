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
('Vanilla, Bean', 'Dry', 'Qty')
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
);

--Use the following to grab ingredient from a location --
/*SELECT ingredient.ingredient_name FROM ingredient, inventory WHERE ingredient.ingredient_id = inventory.ingredient AND inventory.location = 'Bakery';*/

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
('Meat Avenue', 1, 200),
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
