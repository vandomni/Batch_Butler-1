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
	location VARCHAR(255) NOT NULL PRIMARY KEY,
	ingredient INT,
	amount INT,
	FOREIGN KEY (ingredient) REFERENCES ingredient(ingredient_id)
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
('Flour, Hi-Gluten', 'Dry', 'lb')
('Egg product', 'Wet', 'lb'),
('Sugar, Cane', 'Dry', 'lb'),
('Flour, Lo-Gluten', 'Dry', 'lb')
;

INSERT INTO recipe (recipe_name, quantity, recipe_type)
VALUES ('Test Cookie', 20, 'Cookie');

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
);
