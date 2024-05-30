-- ======================================================*Inventory Control Management*=================================================================
create database inv_mang; 
use inv_mang;

create table brands(
bid int, bname varchar(20));

alter table brands add primary key(bid);

create table categories(
cid	int,
category_name varchar(20)
);	

alter	table	categories		
add	primary	key(cid);	

create table inv_user(
 user_id varchar(20),
 name varchar(20),
 password varchar(20),
 last_login timestamp,
 user_type varchar(10)
 );

alter	table	inv_user		
add	primary	key(user_id);

create	table	product(	
pid	int	primary	key,
cid	int	references	categories(cid),
bid	int	references	brands(bid),
sid	int,		
pname	varchar(20),		
p_stock	int,		
price	int,		
added_date	date);		


create	table	stores(
sid	int,	
sname	varchar(20),	
address	varchar(20),	
mobno	int	
);

ALTER TABLE stores MODIFY COLUMN mobno VARCHAR(10);
 
alter table	stores			
add	primary	key(sid);	

	
alter	table	product			
add	foreign	key(sid)references	stores(sid);

	
create	table	provides(			
bid	int references	brands(bid),			
sid	int references	stores(sid),			
discount	int );			

create	table	customer_cart(	
cust_id	int	primary	key,
name	varchar(20),		
mobno	int		
);

alter table customer_cart modify column mobno varchar(20);
create	table	select_product(	
cust_id	int	references	customer_cart(cust_id),
pid	int references	product(pid),	
quantity	int(4)		
);			
	
create	table	transaction(			
id	int	primary	key,		
total_amount	int,				
paid	int,				
due	int,				
gst	int,				
discount	int,				
payment_method	varchar(10),				
cart_id	int	references	customer_cart(cust_id));
    
	
create	table	invoice(
item_no	int,	
product_name	varchar(20),	
quantity	int,	
net_price	int,	
transaction_id	int references	transaction(id)
);		

	
	insert	into	brands	values(1,'Apple');			

insert	into	brands	values(2,'Samsung');	
insert	into	brands	values(3,'Nike');	
insert	into	brands	values(4,'Fortune');	

			

INSERT INTO inv_user (user_id, name, password, last_login, user_type) VALUES
('harsh@gmail.com', 'Harsh Khanelwal', '1111', STR_TO_DATE('30-oct-18 10:20', '%d-%b-%y %H:%i'), 'Manager');

INSERT INTO inv_user (user_id, name, password, last_login, user_type) VALUES
('prashant@gmail.com', 'Prashant', '0011', STR_TO_DATE('29-oct-18 10:20', '%d-%b-%y %H:%i'), 'Accountant');
		
INSERT INTO inv_user (user_id, name, password, last_login, user_type) VALUES
('vidit@gmail.com', 'vidit', '1234', STR_TO_DATE('31-Oct-18 12:40', '%d-%b-%y %H:%i'), 'admin');



insert	into	categories	values('1','Electroincs');	
insert	into	categories	values(2,'Clothing');	
insert	into	categories	values(3,'Grocey');	

		
insert	into	stores	values('1','Ram	kumar','Katpadi	vellore','9999999999');	
insert	into	stores	values(2,'Rakesh	kumar','chennai',8888555541);		
insert	into	stores	values(3,'Suraj','Haryana',7777555541);			


insert	into product values('1','1','1','1','IPHONE','4','45000', STR_TO_DATE('31-oct-18','%d-%b-%y'));

INSERT INTO product (id, category_id, supplier_id, warehouse_id, product_name, quantity, price, manufacture_date)
VALUES ('1', '1', '1', '1', 'IPHONE', '4', '45000', STR_TO_DATE('31-oct-18', '%d-%b-%y'));

insert	into	product	values(2,1,1,1,'Airpods',3,19000,STR_TO_DATE('27-oct-18', '%d-%b-%y'));	
insert	into	product	values(3,1,1,1,'Smart	Watch',3,19000,STR_TO_DATE('27-oct-18', '%d-%b-%y'));
insert	into	product	values(4,2,3,2,'Air	Max',6,7000,STR_TO_DATE('27-oct-18', '%d-%b-%y'));
insert	into	product	values(5,3,4,3,'REFINED	OIL',6,750,STR_TO_DATE('25-oct-18', '%d-%b-%y'));


insert	into	provides	values(1,1,12);
			
insert	into	provides	values(2,2,7);
			
insert	into	provides	values(3,3,15);
			
insert	into	provides	values(1,2,7);
		
insert	into	provides	values(4,2,19);
		
insert	into	provides	values(4,3,20);


insert	into	customer_cart	values('1','Ram',9876543210);
insert	into	customer_cart	values(2,'Shyam',7777777777);
insert	into	customer_cart	values(3,'Mohan',7777777775);


insert	into	select_product	values('1','2','2');
insert	into	select_product	values(1,3,1);
insert	into	select_product	values(2,3,3);
insert	into	select_product	values(3,2,1);


-- insert into transaction
insert	into	transaction	values('1','25000','20000','5000','350','350','card','1');
insert	into	transaction	values(2,57000,57000,0,570,570,'cash',2);	
insert	into	transaction	values(3,19000,17000,2000,190,190,'cash',3);


SELECT * FROM Brands;
SELECT * FROM inv_user;
SELECT * FROM Categories;
SELECT * FROM Product;
SELECT * FROM Stores;
SELECT * FROM Provides;
SELECT * FROM Customer_cart;
SELECT * FROM Select_product;
SELECT * FROM Transaction;
SELECT * FROM invoice;

It is function for returning id for which we have to calculate the dues for that.
-- create function
DELIMITER //
CREATE FUNCTION get_cart(id int)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN id;
END //
DELIMITER ;
 
 
 -- Below is the procedure for selecting the due in the stock for the material
 
-- Create the procedure
DELIMITER $$

CREATE PROCEDURE get_due(IN c_id INT)
deterministic
BEGIN
    DECLARE due1 DECIMAL(10,2);
    DECLARE cart_id1 INT;
    DECLARE error_message VARCHAR(255) DEFAULT '';

    -- Error handling block
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET error_message = 'An error occurred';
        SELECT error_message AS ErrorMessage;
    END;

    -- Call the function to get the cart ID
    SET cart_id1 = get_cart(c_id);

    -- Try to select the due amount
    SELECT due INTO due1 FROM `transaction` WHERE cart_id = cart_id1;

    -- Output the due amount
    SELECT due1 AS DueAmount;
END$$

DELIMITER ;


drop procedure get_due;

CALL get_due(3);


-- Below one doesn,t work because inside use of the concate function so we have to replace individually with select statement acting individually.    
-- CURSER --
DELIMITER $$

CREATE PROCEDURE p_product_cursor()
BEGIN
    -- Declare variables to hold fetched data
    DECLARE p_id INT;
    DECLARE p_name VARCHAR(255);
    DECLARE p_stock INT;

    -- Declare variable to handle cursor status
    DECLARE done INT DEFAULT 0;

    -- Declare cursor for product table
    DECLARE p_product CURSOR FOR 
        SELECT pid, pname, p_stock FROM product;

    -- Declare handler for when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open cursor
    OPEN p_product;

    -- Loop through rows
    product_loop: LOOP
        -- Fetch data into variables
        FETCH p_product INTO p_id, p_name, p_stock;

        -- Exit loop if no more rows to fetch
        IF done = 1 THEN
            LEAVE product_loop;
        END IF;

        -- Output data
        SELECT CONCAT(p_id, ' ', p_name, ' ', p_stock);

    END LOOP product_loop;

    -- Close cursor
    CLOSE p_product;
END$$

DELIMITER ;


call p_product_cursor;

drop procedure p_product_cursor;



-- In this is safe and secure way by using 'Cursor' to show the output row- wise.

DELIMITER $$
CREATE PROCEDURE p_product_cursor()
BEGIN
    -- Declare variables to hold fetched data
    DECLARE p_id INT;
    DECLARE p_name VARCHAR(255);
    DECLARE p_stock INT;

    -- Declare variable to handle cursor status
    DECLARE done INT DEFAULT 0;

    -- Declare cursor for product table
    DECLARE p_product CURSOR FOR 
        SELECT pid, pname, p_stock FROM product;

    -- Declare handler for when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open cursor
    OPEN p_product;

    -- Output header
    SELECT 'Product ID', 'Product Name', 'Stock';

    -- Loop through rows
    product_loop: LOOP
        -- Fetch data into variables
        FETCH p_product INTO p_id, p_name, p_stock;

        -- Exit loop if no more rows to fetch
        IF done = 1 THEN
            LEAVE product_loop;
        END IF;

        -- Output data
        SELECT p_id, p_name, p_stock;

    END LOOP product_loop;

    -- Close cursor
    CLOSE p_product;
END$$

DELIMITER ;
-- This is use for to check then minimum value in the stock.
DELIMITER $$
CREATE PROCEDURE check_stock(IN x INT)
BEGIN
    IF x < 2 THEN
        SELECT 'Stock is Less';
    ELSE
        SELECT 'Enough Stock';
    END IF;
END;



DELIMITER $$

CREATE PROCEDURE check_stock_wrapper(IN b INT)
BEGIN
    DECLARE a INT;
    SELECT p_stock INTO a FROM product WHERE pid = b;
    CALL check_stock(a);
END$$

DELIMITER ;

call check_stock_wrapper(1);
