/* ------------------------------------------------------Task 1:- Understanding the Data-------------------------------------------------------

1. Describe the data in hand in your own words.
    Table 1. cust_dimen: Details of all the customers
		
        Customer_Name (TEXT): Name of the customer
        Province (TEXT): Province of the customer
        Region (TEXT): Region of the customer
        Customer_Segment (TEXT): Segment of the customer
        Cust_id (TEXT): Unique Customer ID
	
    Table 2. market_fact: Details of every order item sold
		
        Ord_id (TEXT): Order ID
        Prod_id (TEXT): Prod ID
        Ship_id (TEXT): Shipment ID
        Cust_id (TEXT): Customer ID
        Sales (DOUBLE): Sales from the Item sold
        Discount (DOUBLE): Discount on the Item sold
        Order_Quantity (INT): Order Quantity of the Item sold
        Profit (DOUBLE): Profit from the Item sold
        Shipping_Cost (DOUBLE): Shipping Cost of the Item sold
        Product_Base_Margin (DOUBLE): Product Base Margin on the Item sold
        
    Table 3. orders_dimen: Details of every order placed
		
        Order_ID (INT): Order ID
        Order_Date (TEXT): Order Date
        Order_Priority (TEXT): Priority of the Order
        Ord_id (TEXT): Unique Order ID
	
    Table 4. prod_dimen: Details of product category and sub category
		
        Product_Category (TEXT): Product Category
        Product_Sub_Category (TEXT): Product Sub Category
        Prod_id (TEXT): Unique Product ID
	
    Table 5. shipping_dimen: Details of shipping of orders
		
        Order_ID (INT): Order ID
        Ship_Mode (TEXT): Shipping Mode
        Ship_Date (TEXT): Shipping Date
        Ship_id (TEXT): Unique Shipment ID

2. Identify and list the Primary Keys and Foreign Keys for this dataset provided to you(In case you don’t find either primary or foreign key, then specially mention this in your answer)

   Table 1. cust_dimen
		Primary Key: Cust_id
        Foreign Key: NA
	
    Table 2. market_fact
		Primary Key: NA
        Foreign Key: Ord_id, Prod_id, Ship_id, Cust_id
	
    Table 3. orders_dimen
		Primary Key: Ord_id
        Foreign Key: NA
	
    Table 4. prod_dimen
		Primary Key: Prod_id
        Foreign Key: NA
	
    Table 5. shipping_dimen
		Primary Key: Ship_id
        Foreign Key: NA

/*

/* --------------------------------------------------------------Task 2:- Basic & Advanced Analysis -----------------------------------------*/

Create Schema Superstores;
USE Superstores;

/* 1.Write a query to display the Customer_Name and Customer Segment using alias name “Customer Name", "Customer Segment" from table Cust_dimen. */

SELECT 
    Customer_Name AS `Customer Name`,
    Customer_Segment AS `Customer Segment`
FROM
    cust_dimen;
    
/* 2.Write a query to find all the details of the customer from the table cust_dimen order by desc. */

SELECT 
    *
FROM
    cust_dimen
ORDER BY Customer_Name DESC;    

/* 3.Write a query to get the Order ID, Order date from table orders_dimen where ‘Order Priority’ is high.*/

SELECT 
    Order_ID, Order_Date
FROM
    orders_dimen
WHERE
    Order_Priority = 'HIGH';
    
 /* 4.Find the total and the average sales (display total_sales and avg_sales). */
 
 SELECT 
    SUM(sales) AS total_sales, AVG(sales) AS avg_sales
FROM
    market_fact;
    
/* 5.Write a query to get the maximum and minimum sales from maket_fact table. */

 SELECT 
    MAX(sales) AS MAX_sales, MIN(sales) AS MIN_sales
FROM
    market_fact;
    
/* 6.Display the number of customers in each region in decreasing order of no_of_customers. The result should contain columns Region, no_of_customers. */

SELECT 
    COUNT(*) AS no_of_customers, Region
FROM
    cust_dimen
GROUP BY Region
ORDER BY COUNT(*) DESC;

/* 7.Find the region having maximum customers (display the region name and max(no_of_customers) */

SELECT 
    COUNT(*) AS no_of_customers, Region
FROM
    cust_dimen
GROUP BY Region
HAVING no_of_customers >= ALL (SELECT 
        COUNT(*) AS no_of_customers
    FROM
        cust_dimen
    GROUP BY region);
 
/* 8.Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased) */

SELECT 
    c.customer_name, COUNT(*) AS no_of_tables_purchased
FROM
    market_fact m
        INNER JOIN
    cust_dimen c ON m.cust_id = c.cust_id
WHERE
    c.region = 'atlantic'
        AND m.prod_id = (SELECT 
            prod_id
        FROM
            prod_dimen
        WHERE
            product_sub_category = 'tables')
GROUP BY m.cust_id , c.customer_name;

/* 9.Find all the customers from Ontario province who own Small Business. (display the customer name, no of small business owners) */

SELECT 
    Customer_Name
FROM                                  /*display the customer name*/
    cust_dimen
WHERE
    Province = 'Ontario'
        AND Customer_Segment = 'SMALL BUSINESS';
        
 SELECT 
    count(*) AS `no of small business owners`
FROM                                         /*no of small business owners*/
    cust_dimen
WHERE
    Province = 'Ontario'
        AND Customer_Segment = 'SMALL BUSINESS';       
        
/* 10.Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold) */
SELECT 
    prod_id AS product_id, COUNT(*) AS no_of_products_sold
FROM
    market_fact
GROUP BY prod_id
ORDER BY no_of_products_sold DESC;

/* 11.Display product Id and product sub category whose produt category belongs to Furniture and Technlogy. The result should contain columns product id, product sub category. */

SELECT 
    Prod_id, Product_Sub_Category
FROM
    prod_dimen
WHERE
    Product_Category IN ('FURNITURE' , 'TECHNOLOGY')
ORDER BY Product_Category;

/* 12.Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)? */

SELECT 
    P.Product_Category, SUM(M.profit) AS Profits
FROM
    prod_dimen AS P
        INNER JOIN
    market_fact AS M ON p.Prod_id = M.Prod_id
GROUP BY P.Product_Category
ORDER BY Profits DESC;
 
/* 13.Display the product category, product sub-category and the profit within each subcategory in three columns. */

SELECT 
    P.Product_Category,p.Product_Sub_Category, SUM(M.profit) AS Profits
FROM
    prod_dimen AS P
        INNER JOIN
    market_fact AS M ON p.Prod_id = M.Prod_id
GROUP BY p.Product_Sub_Category;

/* 14.Display the order date, order quantity and the sales for the order. */

SELECT 
    O.Order_Date, M.Order_Quantity, M.Sales
FROM
    orders_dimen AS O
        INNER JOIN
    market_fact AS M ON O.Ord_id = M.Ord_id;


/* 15.Display the names of the customers whose name contains the
i) Second letter as ‘R’
ii) Fourth letter as ‘D’ */

SELECT 
    Customer_Name
FROM
    cust_dimen
WHERE
    Customer_Name LIKE '_R_D%';
    
/* 16.Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and their region where sales are between 1000 and 5000. */ 

SELECT 
    C.Cust_id AS Cust_Id,
    M.sales AS Sales,
    C.Customer_Name AS `Customer Name`,
    C.Region
FROM
    cust_dimen AS C
        INNER JOIN
    market_fact AS M ON C.Cust_id = M.Cust_id where M.sales between 1000 and 5000;
    
/* 17.Write a SQL query to find the 3rd highest sales. */

SELECT 
    Sales
FROM
    market_fact
ORDER BY sales DESC
LIMIT 1 OFFSET 2;

/* 18.Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the
profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)
→ Note: You can hardcode the name of the least profitable product subcategory */

SELECT 
    c.region,
    COUNT(DISTINCT s.ship_id) AS no_of_shipments,
    SUM(m.profit) AS profit_in_each_region
FROM
    market_fact m
        INNER JOIN
    cust_dimen c ON m.cust_id = c.cust_id
        INNER JOIN
    shipping_dimen s ON m.ship_id = s.ship_id
        INNER JOIN
    prod_dimen p ON m.prod_id = p.prod_id
WHERE
    p.product_sub_category IN (SELECT 
            p.product_sub_category
        FROM
            market_fact m
                INNER JOIN
            prod_dimen p ON m.prod_id = p.prod_id
        GROUP BY p.product_sub_category
        HAVING SUM(m.profit) <= ALL (SELECT 
                SUM(m.profit) AS profits
            FROM
                market_fact m
                    INNER JOIN
                prod_dimen p ON m.prod_id = p.prod_id
            GROUP BY p.product_sub_category))
GROUP BY c.region
ORDER BY profit_in_each_region DESC;