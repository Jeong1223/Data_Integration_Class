DECLARE
  L_C_LAST CLEARWATER.CUSTOMER.C_LAST%TYPE;
  L_NUM_CUST NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO L_NUM_CUST
  FROM CLEARWATER.CUSTOMER;
  DBMS_OUTPUT.PUT_LINE('THERE ARE ' || L_NUM_CUST || ' CUSTOMERS');
  FOR X IN 1..L_NUM_CUST LOOP
    BEGIN
    SELECT DISTINCT C.C_LAST
    INTO L_C_LAST
    FROM CLEARWATER.CUSTOMER C JOIN CLEARWATER.ORDERS O ON (O.C_ID = C.C_ID)
    WHERE C.C_ID = X;
    DBMS_OUTPUT.PUT_LINE ('THE CUSTOMER ' ||X|| ' HAS PLACED AN ORDER');
    EXCEPTION
    --WHEN TOO_MANY_ROWS THEN
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('THE CUSTOMER ' ||X|| ' HAS NOT PLACED AN ORDER');
    END;   
  END LOOP;
END;

