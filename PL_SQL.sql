--PL SQL CODE
SET SERVEROUTPUT ON
DECLARE
  L_NAME VARCHAR2;     
BEGIN
  L_NAME := 'Humna Humna';
END;

--declaration section: declaring variable
DECLARE 
  MY_MESSAGE VARCHAR2(20); 
--executable section
BEGIN
  MY_MESSAGE := 'hELLO wALLY wORLD!';
  DBMS_OUTPUT.PUT_LINE(MY_MESSAGE);
END;


DECLARE
  L_NAME VARCHAR(20) DEFAULT 'Ilsa';
  L_STATUS BOOLEAN := TRUE;
BEGIN
  L_NAME := 'Humna Humna';
  
  IF L_STATUS THEN --IF condition THEN
    DBMS_OUTPUT.PUT_LINE ('IT IS TRUE THAT ' || L_NAME || 'IS SILLY');  --executable statements
  ELSE --ELSIF
    DBMS_OUTPUT.PUT_LINE ('IT IS FALSE THAT ' || L_NAME || 'IS SILLY');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(L_NAME);
END;

--THE PL/SQL CONDITIONAL & BOOLEAN VARIABLE USE

--declaration section
DECLARE 
  MY_FAVORITE_FOOD VARCHAR2(20) DEFAULT 'BULGOGI';
  MY_STATUS BOOLEAN := TRUE;
--executable section
BEGIN
  MY_FAVORITE_FOOD := 'BIBIMBOB';

  IF MY_STATUS THEN --IF condition THEN
    DBMS_OUTPUT.PUT_LINE ('IT IS TRUE THAT ' || MY_FAVORITE_FOOD || ' IS MY FAVORITE FOOD! ');  --executable statements
  ELSE --ELSIF
    DBMS_OUTPUT.PUT_LINE ('IT IS FALSE THAT ' || MY_FAVORITE_FOOD|| ' IS NOT MY FAVORITE FOOD. ');
  END IF;
 
  DBMS_OUTPUT.PUT_LINE(MY_FAVORITE_FOOD);
END;

--LOOP 1
--Different approach
SET SERVEROUP ON
DECLARE
  L_FNAME CUSTOMER.C_FIRST%TYPE;
  L_MI CUSTOMER.C_MI%TYPE;
  L_LNAME CUSTOMER.C_LAST%TYPE;
  L_COUNTER NUMBER := 0;

BEGIN
  LOOP 
      --L_COUNTER := C_ID;
      L_COUNTER := L_COUNTER +1;
      EXIT WHEN L_COUNTER  > 6;
      
      SELECT C_FIRST, C_MI, C_LAST
      INTO L_FNAME, L_MI, L_LNAME
      FROM CUSTOMER
      WHERE C_ID = L_COUNTER;
      
      DBMS_OUTPUT.PUT_LINE('CUSTOMER NAME: '|| L_COUNTER || ' ' || L_FNAME || ' ' || L_MI || ' ' || L_LNAME|| L_MI );
  END LOOP;
--control resumes here after EXIT
--DBMS_OUTPUT.PUT_LINE( 'WE HAVE: ' || l_counter || ' CUSTOMERS' );

END;


--LOOP2
DECLARE
  L_FNAME VARCHAR(30);
  L_MI CHAR(1);
  L_LNAME VARCHAR(30);
  L_COUNTER NUMBER := 0;

BEGIN

  FOR C IN (SELECT C_FIRST, C_MI, C_LAST
            FROM CUSTOMER
            )

LOOP

    L_COUNTER := L_COUNTER + 1;

    --EXIT WHEN L_COUNTER > 7;
    
    DBMS_OUTPUT.PUT_LINE('CUSTOMER NAME: '|| L_COUNTER || ' ' || C.C_FIRST || ' ' || C.C_MI || ' ' || C.C_LAST|| C.C_MI );
   
END LOOP;

--control resumes here after EXIT
DBMS_OUTPUT.PUT_LINE( 'WE HAVE: ' || l_counter || ' CUSTOMERS' );

END;
