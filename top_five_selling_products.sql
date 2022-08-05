
SELECT *
FROM (
    SELECT OD.PRODUCT_ID,
           P.PRODUCT_NAME,
           OD.UNIT_PRICE,
           SUM(QUANTITY),
           SUM(QUANTITY) * OD.UNIT_PRICE as total_sales
    FROM ORDER_DETAILS OD
    INNER JOIN PRODUCTS P on P.PRODUCT_ID = OD.PRODUCT_ID
    INNER JOIN ORDERS on OD.ORDER_ID = ORDERS.ORDER_ID
    WHERE EXTRACT(YEAR FROM ORDERS.ORDER_DATE) = 1998
    GROUP BY OD.PRODUCT_ID, P.PRODUCT_NAME, OD.UNIT_PRICE
    ORDER BY total_sales desc)
WHERE ROWNUM<=5

