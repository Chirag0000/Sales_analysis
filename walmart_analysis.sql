
-- -----Feature Engg. ------
-- time_of_day 
SELECT
	Time,
	(CASE
		WHEN CAST(Time AS TIME) BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN (Time) BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM walmart_analysis.walmart_sales_data; 


ALTER TABLE walmart_analysis.walmart_sales_data ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmart_analysis.walmart_sales_data
SET time_of_day=( 
CASE
 WHEN CAST(Time AS TIME) BETWEEN "00:00:00" AND "12:00:00" THEN "Morning" 
 WHEN Time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
 ELSE "Evening"
 END);

SELECT * FROM walmart_analysis.walmart_sales_data;
 
 --  day_name

SELECT date, DAYNAME(Date) AS day_name FROM walmart_analysis.walmart_sales_data;
ALTER TABLE walmart_analysis.walmart_sales_data ADD COLUMN day_name VARCHAR(245);
 
 UPDATE walmart_analysis.walmart_sales_data
 SET day_name=DAYNAME(Date);
 
 SELECT * FROM walmart_analysis.walmart_sales_data;
 
 -- month_name 
 
SELECT Date, MONTHNAME(Date) FROM walmart_analysis.walmart_sales_data;
ALTER TABLE walmart_analysis.walmart_sales_data ADD COLUMN month_name VARCHAR(245);

UPDATE walmart_analysis.walmart_sales_data
SET month_name=MONTHNAME(Date); 
SELECT * FROM walmart_analysis.walmart_sales_data;

-- Year
SELECT Date, YEAR(Date) FROM walmart_analysis.walmart_sales_data;
ALTER TABLE walmart_analysis.walmart_sales_data ADD COLUMN year1 VARCHAR(245);

UPDATE walmart_analysis.walmart_sales_data
SET year1= YEAR(Date);
SELECT * FROM walmart_analysis.walmart_sales_data;
-------- Business Questions-------

-- -------- Product---------

-- 1) How many unique cities are present?
SELECT DISTINCT City
FROM walmart_analysis.walmart_sales_data;

-- 2) In which city is each branch? 
SELECT DISTINCT City, Branch
FROM walmart_analysis.walmart_sales_data;

-- 3) How many unique product lines does the data have?
 SELECT DISTINCT Product_line
 FROM walmart_analysis.walmart_sales_data;
 
 -- 4) What is the most common payment method?
SELECT Payment, COUNT(Payment) AS times_used
FROM walmart_analysis.walmart_sales_data
GROUP BY Payment
ORDER BY times_used DESC
LIMIT 1;

-- 5) What is the most selling Product line?
SELECT Product_line, SUM(Quantity) AS most_sold
FROM walmart_analysis.walmart_sales_data
GROUP BY Product_line
ORDER BY most_sold DESC;

-- 6)What is the total revenue by month?
SELECT year1, month_name, SUM(cogs)
FROM walmart_analysis.walmart_sales_data
GROUP BY year1,month_name;

-- 7)  What is the city with largest revenue?
SELECT City, SUM(Total) AS total
FROM walmart_analysis.walmart_sales_data
group by City
ORDER BY total DESC;

-- 8) What product line had the largest VAT?
SELECT Product_line, SUM(VAT) AS largest_vat
FROM walmart_analysis.walmart_sales_data
GROUP BY Product_line
ORDER BY largest_vat DESC;



-- 9) Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales?
SELECT Product_line, CASE
                       WHEN Quantity>AVG(Quantity) THEN 'Good'
                       ELSE 'Bad'
                       END AS Title
FROM walmart_analysis.walmart_sales_data
GROUP BY Product_line;


-- 10) Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM walmart_analysis.walmart_sales_data
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmart_analysis.walmart_sales_data);

-- 11)What is the most common product line by gender?
SELECT Gender, Product_line, COUNT(Gender) AS cnt, ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY COUNT(Gender) DESC) AS rnk
FROM walmart_analysis.walmart_sales_data
GROUP BY Gender, Product_line
ORDER BY rnk ASC;

-- 12)What is the average rating of each product line?
SELECT Product_line, AVG(Rating) AS avg_rate
FROM walmart_analysis.walmart_sales_data
GROUP BY Product_line
ORDER BY avg_rate DESC;

-- -----Sales------

-- 1) Which of the customer types brings the most revenue?
SELECT Customer_type, SUM(Total) AS revenue
FROM walmart_analysis.walmart_sales_data
GROUP BY Customer_type
ORDER BY revenue DESC;


-- 2) Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT City, ROUND(VAT/cogs,2) AS tax_pct
FROM walmart_analysis.walmart_sales_data
GROUP BY City
ORDER BY tax_pct DESC;

-- -----Customer---------

-- 1) What is the most common customer type?
SELECT Customer_type, COUNT(customer_type) AS amt
FROM walmart_analysis.walmart_sales_data
GROUP BY Customer_type;

-- 2) Which customer type buys the most?
SELECT Customer_type, SUM(cogs)
FROM walmart_analysis.walmart_sales_data
GROUP BY Customer_type;

-- 3) What is the gender of most of the customers?
SELECT Gender, COUNT(Gender)
FROM walmart_analysis.walmart_sales_data
group by gender;

-- 4) What is the gender distribution per branch?
SELECT Branch, Gender, COUNT(*)
FROM walmart_analysis.walmart_sales_data
group by Branch, gender;



 
 