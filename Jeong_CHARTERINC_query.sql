-- =================================================
-- Assingment 1 - DDL and DML
-- Jeong Eun Jang (w0451032)
-- DBAS 3035 Information Systems Design
-- George Campanis
-- February 4, 2022
-- ==================================================

------------------------------------------------------------------------
-- 1. Create a database only if it dosen't exist
------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'CHARTERINC')
  BEGIN
    CREATE DATABASE [CHARTERINC]
    END

-- use database
Use CHARTERINC;
Go



--------------------------------------------------------------------------------
-- 2. Create TABLE only if it doesn't exist 
--------------------------------------------------------------------------------

-- Create EMPLOYEE table
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[EMPLOYEE]') AND type in (N'U')
)
    BEGIN
        CREATE TABLE EMPLOYEE(
		EMP_NUM BIGINT NOT NULL, 
		EMP_TITLE NVARCHAR(4),
		EMP_LNAME NVARCHAR(15),
		EMP_FNAME NVARCHAR(15),
		EMP_INITIAL NVARCHAR(1),
		EMP_DOB DATETIME,
		EMP_HIRE_DATE DATETIME,
		CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EMP_NUM)
		);
END;

-- Create CUSTOMER table
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].CUSTOMER]') AND type in (N'U')
)
    BEGIN
        CREATE TABLE CUSTOMER(
		CUS_CODE BIGINT NOT NULL,
		CUS_LNAME NVARCHAR(15),
		CUS_FNAME NVARCHAR(15),
		CUS_INITIAL NVARCHAR(1),
		CUS_AREACODE NVARCHAR(3),
		CUS_PHONE NVARCHAR(8),
		CUS_BALANCE REAL,
		CONSTRAINT PK_CUSTOMER PRIMARY KEY (CUS_CODE)
		);
END;

-- creat MODEL table
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].MODEL]') AND type in (N'U')
)
    BEGIN
        CREATE TABLE MODEL(
		MOD_CODE NVARCHAR(10) NOT NULL,
		MOD_MANUFACTURER NVARCHAR(15),
		MOD_NAME NVARCHAR(20),
		MOD_SEATS FLOAT(8),
		MOD_CHG_MILE REAL,
		CONSTRAINT PK_MODEL PRIMARY KEY (MOD_CODE)
		);
END;

-- create AIRCRAFT table
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].AIRCRAFT]') AND type in (N'U')
)
    BEGIN
        CREATE TABLE AIRCRAFT(
		AC_NUMBER NVARCHAR(5) NOT NULL,
		MOD_CODE NVARCHAR(10),
		AC_TTAF FLOAT(8),
		AC_TTEL FLOAT(8),
		AC_TTER FLOAT(8)
		CONSTRAINT PK_AIRCRAFT PRIMARY KEY (AC_NUMBER),
		CONSTRAINT FK_AIRCRAFT FOREIGN KEY (MOD_CODE) REFERENCES MODEL(MOD_CODE)
		ON UPDATE CASCADE
		ON DELETE CASCADE
		);
END;

-- create CHARTER table
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].CHARTER]') AND type in (N'U')
)
    BEGIN
        CREATE TABLE CHARTER(
		CHAR_TRIP BIGINT NOT NULL,
		CHAR_DATE DATETIME,
		AC_NUMBER NVARCHAR(5),
		CHAR_DESTINATION NVARCHAR(3),
		CHAR_DISTANCE REAL,    
		CHAR_HOURS_FLOWN FLOAT(8),
		CHAR_HOURS_WAIT FLOAT(8),
		CHAR_FUEL_GALLONS FLOAT(8),
		CHAR_OIL_QTS INTEGER,
		CUS_CODE BIGINT
		CONSTRAINT PK_CHARTER PRIMARY KEY (CHAR_TRIP)
		);
END;

ALTER TABLE CHARTER
		ADD CONSTRAINT FK_CHARTER FOREIGN KEY (AC_NUMBER) REFERENCES AIRCRAFT(AC_NUMBER),
							      FOREIGN KEY (CUS_CODE) REFERENCES CUSTOMER(CUS_CODE)
		ON UPDATE CASCADE
		ON DELETE CASCADE;
			
-- create CREW table
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].CREW]') AND type in (N'U')
)
    BEGIN
		CREATE TABLE CREW(
		CHAR_TRIP BIGINT,
		EMP_NUM BIGINT,
		CREW_JOB NVARCHAR(20)
		CONSTRAINT PK_CREW PRIMARY KEY (CHAR_TRIP, EMP_NUM),
		CONSTRAINT FK_CREW FOREIGN KEY (CHAR_TRIP) REFERENCES CHARTER(CHAR_TRIP),
				           FOREIGN KEY (EMP_NUM) REFERENCES EMPLOYEE(EMP_NUM)
		ON UPDATE CASCADE
		ON DELETE CASCADE
		);
END;

 

 ---------------------------------------------------------
-- 3. insert all data
----------------------------------------------------------

-- insert EMPLOYEE data
INSERT INTO 
	EMPLOYEE(
		EMP_NUM, EMP_TITLE, EMP_LNAME, EMP_FNAME, EMP_INITIAL, EMP_DOB, EMP_HIRE_DATE
)
VALUES
	(100,'Mr.','Kolmycz','George','D','1952-6-15','2007-3-15'), --datetime 'YYYY-MM-DD'
	(101,'Ms.','Lewis','Rhonda','G','1975-3-19','2008-4-25'),
	(102,'Mr.','VanDam','Rhett',' ','1968-11-14','2012-12-20'), --no middle name  
	(103,'Ms.','Jones','Anne','M','1984-10-16','2015-8-28'),
	(104,'Mr.','Lange','John','P','1981-11-8','2006-10-20'),  
	(105,'Mr.','Williams','Robert','D','1985-3-14','2015-1-8'),  
	(106,'Mrs.','Duzak','Jeanine','K','1978-2-12','2011-1-5'),  
	(107,'Mr.','Diante','Jorge','D','1984-8-21','2006-7-2'),  
	(108,'Mr.','Wiesenbach','Paul','R','1976-2-14','2014-11-18'),  
	(109,'Ms.','Travis','Elizabeth','K','1971-6-18','2011-4-14'),  
	(110,'Mrs.','Genkazi','Leighla','W','1980-5-19','2012-12-1')  


-- insert CUSTOMER data
INSERT INTO
	CUSTOMER(
		CUS_CODE, CUS_LNAME , CUS_FNAME , CUS_INITIAL , CUS_AREACODE , CUS_PHONE , CUS_BALANCE 
)
VALUES
	(10010,'Ramas','Alfred','A','615','844-2573',0.00),
	(10011,'Dunne','Leona','K','713','894-1238',0.00),
	(10012,'Smith','Kathy','W','615','894-2285',896.54),
	(10013,'Olowski','Paul','F','615','894-2180',1285.19),
	(10014,'Orlando','Myron',' ','615','222-1672',673.21), --no middle name
	(10015,'O''Brian','Amy','B','713','442-3381',1014.56), --single quote escape
	(10016,'Brown','James','G','615','297-1228',0.00),
	(10017,'Williams','George',' ','615','290-2556',0.00), --no middle name
	(10018,'Farriss','Anne','G','713','382-7185',0.00),
	(10019,'Smith','Olette','K','615','297-3809',453.98)


--insert MODEL data
INSERT INTO
	MODEL(
		MOD_CODE,MOD_MANUFACTURER,MOD_NAME,MOD_SEATS,MOD_CHG_MILE
)
VALUES
	('C-90A','Beechcraft','KingAir',8.00,2.67),	
	('PA23-250','Piper','Aztec',6.00,1.93),	
	('PA31-350','Piper','Navajo Chieftain',10.00,2.35)	

--insrt AIRCRAFT data
INSERT INTO
	AIRCRAFT(
		AC_NUMBER, MOD_CODE, AC_TTAF, AC_TTEL, AC_TTER
)
VALUES
	('1484P','PA23-250',1833.10,1833.10,101.80), -- float 1833.10 -> 1833.1 ?
	('2289L','C-90A',4243.80,768.90,1123.40),
	('2778V','PA31-350',7992.90,1513.10,789.50),
	('4278Y','PA31-350',2147.30,622.10,243.20)


--insert CHARTER data
INSERT INTO
	CHARTER(
		CHAR_TRIP,CHAR_DATE,AC_NUMBER,CHAR_DESTINATION,CHAR_DISTANCE,CHAR_HOURS_FLOWN,CHAR_HOURS_WAIT,CHAR_FUEL_GALLONS,CHAR_OIL_QTS,CUS_CODE
)
VALUES 
    (10001,'2016-2-5','2289L','ATL',936.00,5.10,2.20,354.10,1,10011), 					
	(10002,'2016-2-5','2778V','BNA',320.00,1.60,0.00,72.60,0,10016),						
	(10003,'2016-2-5','4278Y','GNV',1574.00,7.80,0.00,339.80,2,10014),						
	(10004,'2016-2-6','1484P','STL',472.00,2.90,4.90,97.20,1,10019),						
	(10005,'2016-2-6' ,'2289L','ATL',1023.00,5.70,3.50,397.70,2,10011),						
	(10006,'2016-2-6' ,'4278Y','STL',472.00,2.60,5.20,117.10,0,10017),						
	(10007,'2016-2-6' ,'2778V','GNV',1574.00,7.90,0.00,348.40,2,10012),						
	(10008,'2016-2-7' ,'1484P','TYS',644.00,4.10,0.00,140.60,1,10014),						
	(10009,'2016-2-7' ,'2289L','GNV',1574.00,6.60,23.40,459.90,0,10017),						
	(10010,'2016-2-7' ,'4278Y','ATL',998.00,6.20,3.20,279.70,0,10016),						
	(10011,'2016-2-7' ,'1484P','BNA',352.00,1.90,5.30,66.40,1,10012),						
	(10012,'2016-2-8' ,'2778V','MOB',884.00,4.80,4.20,215.10,0,10010),						
	(10013,'2016-2-8' ,'4278Y','TYS',644.00,3.90,4.50,174.30,1,10011),						
	(10014,'2016-2-9' ,'4278Y','ATL',936.00,6.10,2.10,302.60,0,10017),						
	(10015,'2016-2-9' ,'2289L','GNV',1645.00,6.70,0.00,459.50,2,10016),						
	(10016,'2016-2-9' ,'2778V','MQY',312.00,1.50,0.00,67.20,0,10011),						
	(10017,'2016-2-10' ,'1484P','STL',508.00,3.10,0.00,105.50,0,10014),						
	(10018,'2016-2-10' ,'4278Y','TYS',644.00,3.80,4.50,167.40,0,10017)	

-- insert CREW data
INSERT INTO
	CREW(
		CHAR_TRIP,EMP_NUM,CREW_JOB
)
VALUES
	(10001,104,'Pilot'),
	(10002,101,'Pilot'),
	(10003,105,'Pilot'),
	(10003,109,'Copilot'),
	(10004,106,'Pilot'),
	(10005,101,'Pilot'),
	(10006,109,'Pilot'),
	(10007,104,'Pilot'),
	(10007,105,'Copilot'),
	(10008,106,'Pilot'),
	(10009,105,'Pilot'),
	(10010,108,'Pilot'),
	(10011,101,'Pilot'),
	(10011,104,'Copilot'),
	(10012,101,'Pilot'),
	(10013,105,'Pilot'),
	(10014,106,'Pilot'),
	(10015,101,'Copilot'),
	(10015,104,'Pilot'),
	(10016,105,'Copilot'),
	(10016,109,'Pilot'),
	(10017,101,'Pilot'),
	(10018,104,'Copilot'),
	(10018,105,'Pilot')


----------------------------------------
-- 4. create a Stored Procedure
----------------------------------------

-- create a stored procedure
USE CHARTERINC
GO  --when begin a new batch

CREATE PROC spAddAircraft
	(
		@AC_NUM AS NVARCHAR(5), 
		@MODEL_CODE AS NVARCHAR(10),
		@AC_TTAF AS FLOAT(8),
		@AC_TTEL AS FLOAT(8),
		@AC_TTER AS BIGINT
	)
AS
BEGIN
	INSERT INTO 
		AIRCRAFT(
			AC_NUMBER, MOD_CODE, AC_TTAF, AC_TTEL, AC_TTER
	)
	VALUES(
		@AC_NUM, @MODEL_CODE, @AC_TTAF, @AC_TTEL, @AC_TTER
	)
END

--execute
EXEC spADDAircraft '2290L', 'C-90A', 4243.8, 768.9, 1123.4;


-----------------------------------------------
-- 5. create a VIEW
-----------------------------------------------
USE CHARTERINC
GO

--5.1 Using NOT IN & Subquery
CREATE VIEW FlownYetAircraft1
AS
SELECT *
FROM AIRCRAFT
WHERE AC_NUMBER NOT IN (
			SELECT A.AC_NUMBER
			FROM AIRCRAFT A 
			JOIN CHARTER C 
			ON (A.AC_NUMBER = C.AC_NUMBER))

SELECT * FROM FlownYetAircraft1

--5.2 Using IS NULL
CREATE VIEW FlownYetAircraft2
AS
SELECT A.AC_NUMBER, A.AC_TTAF, A.AC_TTEL, A.AC_TTER
FROM AIRCRAFT A 
		LEFT JOIN CHARTER C 
		ON (A.AC_NUMBER = C.AC_NUMBER)
WHERE C.CHAR_TRIP IS NULL;

SELECT * FROM FlownYetAircraft2



-----------------------------------------------------------------------
--6. Create a query that will show customers who have 
--   a total Charter hours flown great than 7.
-----------------------------------------------------------------------

SELECT C.CUS_FNAME,C.CUS_LNAME, C.CUS_BALANCE 
FROM 
(
	SELECT  C.CUS_CODE, SUM(CHAR_HOURS_FLOWN) TOTAL 
	FROM CUSTOMER C JOIN CHARTER CH ON C.CUS_CODE = CH.CUS_CODE 
	GROUP BY C.CUS_CODE
	HAVING SUM(CHAR_HOURS_FLOWN) > 7
	) T JOIN CUSTOMER C ON (T.CUS_CODE = C.CUS_CODE)
ORDER BY C.CUS_BALANCE DESC


------------------------------------------------------------
--7. 
--WITH cte_pilotHR AS
------------------------------------------------------------
--LEAD(scalar_expression [,offset ], [default]) OVER( [partition_by_clause] order_by_clause)
--DATEDIFF (datepart, startdate, edndate)

--Using a HINT
WITH CharterCoPilots
AS 
--Define the CTE query
(
SELECT  ch.[CHAR_TRIP] ,[CHAR_DATE], [EMP_NUM],
DATEDIFF(HOUR, [CHAR_DATE], LAG([CHAR_DATE], 1) OVER (PARTITION by [EMP_NUM] ORDER BY [CHAR_DATE]))*-1 previousDay
--,DATEDIFF(HOUR, [CHAR_DATE], LEAD([CHAR_DATE], 1) OVER (PARTITION by [EMP_NUM] ORDER BY [CHAR_DATE])) DaysBetweenFlights

FROM [CHARTERINC].[dbo].[CHARTER] CH
inner JOIN
(SELECT [CHAR_TRIP] ,[EMP_NUM]  ,[CREW_JOB]  FROM [CHARTERINC].[dbo].[CREW] where [CREW_JOB] ='pilot')CW
on CH.[CHAR_TRIP]=cw.[CHAR_TRIP]
)

SELECT CHAR_TRIP,[EMP_FNAME], [EMP_LNAME],[EMP_HIRE_DATE] 
FROM
(
	(SELECT * FROM  CharterCoPilots WHERE previousDay = 24) chp  --filtering option from CTE
	 INNER JOIN
	(SELECT  [EMP_NUM],[EMP_LNAME],[EMP_FNAME],[EMP_HIRE_DATE] FROM [CHARTERINC].[dbo].[EMPLOYEE]) emp  
	  On chp.[EMP_NUM] = emp.[EMP_NUM]
)


--My solution
WITH CharterTrip_CTE (CHAR_TRIP, EMP_FNAME, EMP_LNAME, EMP_HIRE_DATE, TimeBetweenTrip)
AS
--Define the CTE query
(
	SELECT CH.CHAR_TRIP, E.EMP_FNAME, E.EMP_LNAME, E.EMP_HIRE_DATE,
		   DATEDIFF(HOUR, [CHAR_DATE], LAG([CHAR_DATE], 1) OVER (PARTITION BY E.[EMP_NUM] 
		   ORDER BY [CHAR_DATE]))
	FROM CHARTER CH JOIN CREW CR ON (CH.CHAR_TRIP = CR.CHAR_TRIP) 
					JOIN EMPLOYEE E ON (CR.EMP_NUM = E.EMP_NUM)
	WHERE CR.CREW_JOB = 'pilot'
)

SELECT CHAR_TRIP, EMP_FNAME, EMP_LNAME, EMP_HIRE_DATE, TimeBetweenTrip
FROM CharterTrip_CTE
WHERE TimeBetweenTrip = -24


