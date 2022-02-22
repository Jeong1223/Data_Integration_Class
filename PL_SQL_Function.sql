select s.ship_id,
       sl.inv_id,
       (ship_date_expected - 7) OrderDate,
       ship_date_expected ExpectedDate,
       sl_date_received ReceivedDate
from shipment_line sl JOIN shipment S ON (sl.ship_id = s.ship_id)


create or replace function totalsales (input_year NUMBER)
RETURN NUMBER
IS 
  l_total_sales NUMBER(4);
BEGIN
  --ADD UP TOTAL SALES FOR THE SPECIFIED IN THE FUNCTION CALL
  --RETURN THE TOTAL SALES
    SELECT SUM(i.inv_price * ol.ol_quantity)
    INTO l_total_sales
    FROM order_line ol
    JOIN inventory i ON (ol.inv_id = i.inv_id)
    JOIN orders o ON (o.o_id = ol.o_id)
     --WHERE TO_CHAR(o.o_date, 'YYYY') = input_year;
    GROUP BY EXTRACT(YEAR FROM o.o_date)
    HAVING EXTRACT(YEAR FROM o.o_date) = input_year;
    
    -- return the total sales
    RETURN l_total_sales;

END;



DECLARE
    l_sales_2006 NUMBER := 0;
BEGIN
    l_sales_2006 := totalsales (2006);
    DBMS_OUTPUT.PUT_LINE('Sales 2006: ' || l_sales_2006);
END;


SELECT
    totalsales(2006)
FROM
    dual;
