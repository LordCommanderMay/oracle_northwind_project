
    --Combining first last names with concat pipe operator
    SELECT em.FIRSTNAME || ' ' ||em.LASTNAME AS NAME,
           em.TITLE, --get employee title
           SUM(SUBTOTAL) as TOTAL_SALES, -- Calculate Total Sales for each employee
           em.SALARY, -- Get Employee Salary
           -- Calculate profits made by each employee
           SUM(SUBTOTAL) - em.SALARY AS EMPLOYEE_PROFIT
    FROM ORDERS --getting order details id from order
    -- joining order table to get orders by the employee who made the sale
    INNER JOIN EMPLOYEES em ON ORDERS.EMPLOYEE_ID = em.EMPLOYEE_ID
    INNER JOIN ( -- Subquery to calculate subtotal for each order
        SELECT
            ORDERS.ORDER_ID, SUM(od.QUANTITY * od.UNIT_PRICE) AS SUBTOTAL --Calculate subtotal
        FROM ORDERS -- select from orders to get order id
        --join to get unit price and quantity purchase
        INNER JOIN ORDER_DETAILS od ON ORDERS.ORDER_ID = OD.ORDER_ID
        GROUP BY ORDERS.ORDER_ID -- group by order id so sum of all the orders can be calculated
            ) SUBTOTAL ON ORDERS.ORDER_ID = SUBTOTAL.ORDER_ID -- joining on order id from both tables
    -- only grab data from the current year or in this case the most current year
    WHERE EXTRACT(YEAR FROM ORDERS.ORDER_DATE) = 1998
    -- group together these field so subtotal can be calculated
    GROUP BY em.FIRSTNAME, em.LASTNAME, em.SALARY, em.TITLE
    ORDER BY TOTAL_SALES DESC



