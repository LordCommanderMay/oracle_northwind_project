



create or replace FUNCTION TO_DOLLARS(amount IN NUMBER)
    --Converts DECIMAL to VARCHAR2 in dollar format
    RETURN VARCHAR2 -- Return data type
    IS dollars VARCHAR2(130); -- initialize return variable

    BEGIN -- fm: justify left. L: Local Currency Symbol. G: for comma separation. D decimal positions
        -- example $100,000,000,000.00
        RETURN(TO_CHAR(amount, 'fmL999G999G999G999D00'));
    end TO_DOLLARS;



CREATE OR REPLACE VIEW shipping_invoice AS
SELECT
       ORDERS.ORDER_ID AS Order_Number,
       TO_CHAR(ORDERS.ORDER_DATE, 'mm/dd/yyyy') AS Order_Date,
       ORDERS.CUSTOMER_ID AS CUSTOMER_ID,
       ship.COMPANY_NAME AS Ship_By,
       TO_CHAR(ORDERS.SHIPPED_DATE, 'mm/dd/yyyy') AS Ship_Date,
       CUSTOMERS.CONTACT_NAME AS Contact_Name,
       ORDERS.COMPANY_NAME AS Company_Name,
       ORDERS.SHIP_ADDRESS AS Street_Adress,
       -- concatenate city, region, and zip into on field example: Boise,ID 83720
       ORDERS.SHIP_CITY || ',' || ORDERS.ship_region || ' ' || ORDERS.ship_postal_code AS City_State_Zip,
       ORDERS.SHIP_COUNTRY AS Country,
       CUSTOMERS.Phone AS Phone,
       Subtotal AS "Subtotal",
       TO_DOLLARS(ORDERS.FREIGHT) AS Shipping_Cost,
       -- concatenate employee info into on line Margaret Peacock, (206)-555-8122,mpeacock@northwind.com
       em.FIRSTNAME || ' ' || em.LASTNAME || ', ' || em."Phone_Number" || ',' || em.EMAIL as Rep_Info,
       --Calculate tax using .06 demonstration purpose only
       TO_DOLLARS(Subtotal * .06 ) AS "Tax",
       -- Calculate grand total with subtotal tax and shipping cost
       TO_DOLLARS( Subtotal + (Subtotal * .06) + ORDERS.Freight) AS "Total"
FROM
    ORDERS -- Select from order to obtain order_id ship date etc...
    -- joining with CUSTOMERS to obtain CUSTOMERS.CONTACT_NAME
    INNER JOIN CUSTOMERS on CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID
    -- joining with SHIPPERS to obtain shipper name
    INNER JOIN SHIPPERS ship on ORDERS.SHIP_VIA = ship.SHIPPER_ID
    --joining with EMPLOYEE to obtain employee contact name
    INNER JOIN EMPLOYEES em on ORDERS.EMPLOYEE_ID = em.EMPLOYEE_ID
    INNER JOIN ( -- inner join with sub-query that calculates subtotal of order
        SELECT -- select order_id for ON statement and calculate subtotal
            ORDERS.ORDER_ID, SUM(OD.QUANTITY * OD.UNIT_PRICE) as Subtotal
        FROM ORDERS -- from orders to obtain order_id for outer ON statement
            -- join with order_details to obtain quantity and unit price for each product on the order
            INNER JOIN ORDER_DETAILS OD on ORDERS.ORDER_ID = OD.ORDER_ID
            GROUP BY ORDERS.ORDER_ID
            ) Subtotal ON ORDERS.ORDER_ID = Subtotal.ORDER_ID




-- Item List Query
CREATE OR REPLACE VIEW shipping_invoice_item_details AS
    SELECT ORDERS.ORDER_ID,
           P.PRODUCT_NAME as description,
           OD.QUANTITY as qty,
           TO_DOLLARS(OD.UNIT_PRICE) as unit_price,
           -- calculate total for each product
           TO_DOLLARS(OD.QUANTITY * P.UNIT_PRICE ) AS Amount
    FROM ORDERS -- from orders to get order id
    --join order details to obtain order quantities
    INNER JOIN ORDER_DETAILS OD on ORDERS.ORDER_ID = OD.ORDER_ID
    -- join with products to obtain product names
    INNER JOIN PRODUCTS P on OD.PRODUCT_ID = P.PRODUCT_ID
