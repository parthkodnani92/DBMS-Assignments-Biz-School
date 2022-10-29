-- script to create Enterprise database
-- revised 3/2/2004 YZ
-- revised 9/4/2009 LR
-- revised 10/15/2014 AL
-- revised 10/9/2015 AL
-- revised 10/5/2018 AL
-- revised 9/6/2021 AL

USE BUDT703_DB_Student_019;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS [Enterprise.Dependent];
DROP TABLE IF EXISTS [Enterprise.Work];
DROP TABLE IF EXISTS [Enterprise.Project];
DROP TABLE IF EXISTS [Enterprise.DepartmentLocation];
IF EXISTS (
	SELECT *
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'Enterprise.Department' AND TABLE_SCHEMA = 'dbo' )
	ALTER TABLE [Enterprise.Department]
		DROP CONSTRAINT IF EXISTS fk_Department_mgrEmpSSN;
DROP TABLE IF EXISTS [Enterprise.Employee];
DROP TABLE IF EXISTS [Enterprise.Department];

CREATE TABLE [Enterprise.Department] (
	dptId CHAR(2) NOT NULL,
	dptName VARCHAR(20),
	mgrEmpSSN CHAR(9),
	mgrStartDate DATE,
	CONSTRAINT pk_Department_dptId PRIMARY KEY (dptId) );

INSERT INTO [Enterprise.Department] VALUES
	('D1','Headquaters','888665555','1981-06-19'),
	('D4','Administration','987654321','1995-01-01'),
	('D5','Research','333445555','1988-05-22');

CREATE TABLE [Enterprise.Employee] (
	empSSN CHAR(9) NOT NULL,
	empFName VARCHAR(10),
	empMInit CHAR,
	empLName VARCHAR(10),
	empDOB DATE,
	empGender CHAR,
	empStreet VARCHAR(20),
	empCity VARCHAR(10),
	empState CHAR(2),
	empZip CHAR(5),
	empSalary DECIMAL(5),
	sprEmpSSN CHAR(9),
	dptId CHAR(2),
	CONSTRAINT pk_Employee_empSSN PRIMARY KEY (empSSN),
	CONSTRAINT fk_Employee_sprEmpSSN FOREIGN KEY (sprEmpSSN)
		REFERENCES [Enterprise.Employee] (empSSN)
		ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_Employee_dptId FOREIGN KEY (dptId)
		REFERENCES [Enterprise.Department] (dptId)
		ON DELETE NO ACTION ON UPDATE NO ACTION );

INSERT INTO [Enterprise.Employee] VALUES
	('888665555','James','E','Borg','1937-11-10','M','450 Stone St','Houston','TX','77061',55000,NULL,'D1'),
	('987654321','Jennifer','S','Wallace','1941-06-20','F','291 Berry Rd','Bellaire','TX','77022',43000,'888665555','D4'),
	('987987987','Ahmad','V','Jabbar','1969-03-29','M','980 Dallas St','Houston','TX','77002',25000,'987654321','D4'),
	('999887777','Alicia','J','Zelaya','1968-01-19','F','3321 Castle Dr','Spring','TX','77093',25000,'987654321','D4'),
	('333445555','Franklin','T','Wong','1955-12-08','M','638 Voss Rd','Houston','TX','77024',40000,'888665555','D5'),
	('453453453','Joyce','A','English','1972-07-31','F','5631 S Rice Ave','Houston','TX','77081',25000,'333445555','D5'),
	('666884444','Ramesh','K','Narayan','1962-09-15','M','975 Oak Limb Ln','Humble','TX','77338',38000,'333445555','D5'),
	('123456789','John','B','Smith','1965-01-09','M','731 Fondren Rd','Houston','TX','77489',30000,'333445555','D5');

ALTER TABLE [Enterprise.Department]
	ADD CONSTRAINT fk_Department_mgrEmpSSN FOREIGN KEY (mgrEmpSSN)
		REFERENCES [Enterprise.Employee] (empSSN)
		ON DELETE NO ACTION ON UPDATE NO ACTION ;

CREATE TABLE [Enterprise.DepartmentLocation] (
	dptId CHAR(2) NOT NULL,
	dptLoc VARCHAR(20) NOT NULL,
	CONSTRAINT pk_DepartmentLocation_dptId_dptLoc PRIMARY KEY (dptId,dptLoc),
	CONSTRAINT fk_DepartmentLocation_dptId FOREIGN KEY (dptId)
		REFERENCES [Enterprise.Department] (dptId)
		ON DELETE CASCADE ON UPDATE CASCADE );

INSERT INTO [Enterprise.DepartmentLocation] VALUES
	('D1','Houston'),
	('D4','Stafford'),
	('D5','Bellaire'),
	('D5','Sugarland'),
	('D5','Houston');

CREATE TABLE [Enterprise.Project] (
	prjId CHAR(3) NOT NULL,
	prjName VARCHAR(20),
	prjLoc VARCHAR(20),
	dptId CHAR(2),
	CONSTRAINT pk_Project_prjId PRIMARY KEY (prjId),
	CONSTRAINT fk_Project_dptId FOREIGN KEY (dptId)
		REFERENCES [Enterprise.Department] (dptId)
		ON DELETE CASCADE ON UPDATE CASCADE );

INSERT INTO [Enterprise.Project] VALUES
	('P01','ProductX','Bellaire','D5'),
	('P02','ProductY','Sugarland','D5'),
	('P03','ProductZ','Houston','D5'),
	('P10','Computerization','Stafford','D4'),
	('P20','Reorganization','Houston','D1'),
	('P30','Newbenifits','Stafford','D4');

CREATE TABLE [Enterprise.Work] (
	empSSN CHAR(9) NOT NULL,
	prjId CHAR(3) NOT NULL, 
	hours DECIMAL(3,1),
	CONSTRAINT pk_Work_empSSN_prjId PRIMARY KEY (empSSN,prjId),
	CONSTRAINT fk_Work_empSSN FOREIGN KEY (empSSN)
		REFERENCES [Enterprise.Employee] (empSSN)
		ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_Work_prjId FOREIGN KEY (prjId)
		REFERENCES [Enterprise.Project] (prjId)
		ON DELETE NO ACTION ON UPDATE NO ACTION );

INSERT INTO [Enterprise.Work] VALUES
	('123456789','P01',32.5),
	('123456789','P02',7.5),
	('666884444','P03',40.0),
	('453453453','P01',20.0),
	('453453453','P02',20.0),
	('333445555','P02',10.0),
	('333445555','P03',10.0),
	('333445555','P10',10.0),
	('333445555','P20',10.0),
	('999887777','P30',30.0),
	('999887777','P10',10.0),
	('987987987','P10',35.0),
	('987987987','P30',5.0),
	('987654321','P30',20.0),
	('987654321','P20',15.0),
	('888665555','P20',NULL);

CREATE TABLE [Enterprise.Dependent] (
	empSSN CHAR(9) NOT NULL,
	dpdName VARCHAR(20) NOT NULL,
	dpdDOB DATE,
	dpdGender CHAR,
	relationship VARCHAR(20),
	CONSTRAINT pk_Dependent_empSSN_dpdName PRIMARY KEY (empSSN,dpdName),
	CONSTRAINT fk_Dependent_empSSN FOREIGN KEY (empSSN)
		REFERENCES [Enterprise.Employee] (empSSN)
		ON DELETE CASCADE ON UPDATE CASCADE );

INSERT INTO [Enterprise.Dependent] VALUES
	('333445555','Alice','1986-04-05','F','Daughter'),
	('333445555','Theodore','1983-10-25','M','Son'),
	('333445555','Joy','1958-05-03','F','Spouse'),
	('987654321','Abner','1942-02-28','M','Spouse'),
	('123456789','Michael','1988-01-01','M','Son'),
	('123456789','Alice','1988-12-31','F','Daughter'),
	('123456789','Elizabeth','1967-05-05','F','Spouse');

COMMIT;

-- SQL QUERIES --

-- Query 1 : What are the full details of all employees in the alphabetical order of last then first names within every department?

SELECT * 
FROM [Enterprise.Employee]
ORDER BY dptId, empLName, empFName;

-- Query 2 : How many unique department locations?

SELECT COUNT(DISTINCT dptLoc) AS DepartmentLocations
FROM [Enterprise.DepartmentLocation];
-- Answer : 4

-- Query 3 : What are the managers' names and the corresponding department names, in the alphabetical order of last then first names?

SELECT [Enterprise.Department].mgrEmpSSN, [Enterprise.Employee].empFName, [Enterprise.Employee].empMInit,[Enterprise.Employee].empLName, [Enterprise.Department].dptName
FROM [Enterprise.Department], [Enterprise.Employee]
WHERE [Enterprise.Department].mgrEmpSSN = [Enterprise.Employee].empSSN
ORDER BY empLName, empFName;

-- Query 4 : For each department name, how many employees in the department, in the order of department names?

SELECT [Enterprise.Department].dptId, [Enterprise.Department].dptName, COUNT([Enterprise.Department].dptName) AS noOfEmp
FROM [Enterprise.Department], [Enterprise.Employee]
WHERE [Enterprise.Department].dptId = [Enterprise.Employee].dptId
GROUP BY [Enterprise.Department].dptId, [Enterprise.Department].dptName, [Enterprise.Department].dptName
ORDER BY dptName;

-- Query 5 : For each department name, how many locations in the department, in the order of department names?

SELECT [Enterprise.Department].dptId, [Enterprise.Department].dptName, COUNT([Enterprise.Department].dptName) AS noOfLoc
FROM [Enterprise.Department], [Enterprise.DepartmentLocation]
WHERE [Enterprise.Department].dptId = [Enterprise.DepartmentLocation].dptId
GROUP BY [Enterprise.Department].dptId, [Enterprise.Department].dptName, [Enterprise.Department].dptName
ORDER BY dptName;

-- Query 6 : What are employee names, in the alphabetical order of their last then first names, who work on projects organized by the research department?

SELECT DISTINCT [Enterprise.Employee].empLName, [Enterprise.Employee].empMInit, [Enterprise.Employee].empFName
FROM [Enterprise.Department]
FULL JOIN [Enterprise.Employee] ON [Enterprise.Department].dptId = [Enterprise.Employee].dptId
FULL JOIN [Enterprise.Project] ON [Enterprise.Department].dptId = [Enterprise.Project].dptId
WHERE [Enterprise.Department].dptName = 'Research'
ORDER BY empLName, empFName;

-- Query 7 : What are employee names, in the alphabetical order of their last then first names, and numbers of worked projects, where the employee worked on at least two projects?

SELECT [Enterprise.Employee].empFName, [Enterprise.Employee].empMInit, [Enterprise.Employee].empLName, COUNT([Enterprise.Work].prjId) AS NoOfProjects
FROM [Enterprise.Employee], [Enterprise.Work]
WHERE [Enterprise.Employee].empSSN = [Enterprise.Work].empSSN
GROUP BY [Enterprise.Employee].empFName, [Enterprise.Employee].empLName, [Enterprise.Employee].empMInit
HAVING COUNT([Enterprise.Work].prjId) >= 2
ORDER BY empLName, empFName;

-- Query 8 : What are all details of a department, which organizes more than one project?

SELECT DISTINCT [Enterprise.Department].*
FROM [Enterprise.Department]
WHERE [Enterprise.Department].dptId IN(
	SELECT [Enterprise.Project].dptId
	FROM [Enterprise.Project]
	GROUP BY [Enterprise.Project].dptId
	HAVING COUNT([Enterprise.Project].prjId) > 1
);

-- Query 9 : What are all details of managers in the departments, for which more than three employees work in?

SELECT *
FROM [Enterprise.Employee]
WHERE [Enterprise.Employee].empSSN IN (
	SELECT [Enterprise.Department].mgrEmpSSN
	FROM [Enterprise.Department]
	WHERE [Enterprise.Department].dptId IN (
		SELECT [Enterprise.Employee].dptId
		FROM [Enterprise.Employee]
		GROUP BY [Enterprise.Employee].dptId
		HAVING COUNT([Enterprise.Employee].dptId) > 3));

-- Query 10 : What are all details about the oldest employee?

SELECT *
FROM [Enterprise.Employee]
WHERE empDOB = (SELECT MIN(empDOB)
				FROM [Enterprise.Employee]);

-- Query 11 : What are all details about employees, who have letter 'e' in the name?

SELECT *
FROM [Enterprise.Employee]
WHERE empFName LIKE '%e%' OR empMInit LIKE '%e%' OR empLName LIKE '%e%';

-- Query 12 : What are all details of a dependent, who has the same gender as the corresponding employee, using correlated subquery?

SELECT *
FROM [Enterprise.Dependent]
WHERE EXISTS (
	SELECT [Enterprise.Employee].empGender
	FROM [Enterprise.Employee]
	WHERE [Enterprise.Employee].empGender = [Enterprise.Dependent].dpdGender AND [Enterprise.Employee].empSSN = [Enterprise.Dependent].empSSN);

-- Query 13 : What are the cities, where there is either a department or a project?

SELECT [Enterprise.DepartmentLocation].dptLoc
FROM [Enterprise.DepartmentLocation]
UNION
SELECT [Enterprise.Project].prjLoc
FROM [Enterprise.Project];

-- Query 14 : What are the cities, where there is both department and project?

SELECT [Enterprise.DepartmentLocation].dptLoc
FROM [Enterprise.DepartmentLocation]
INTERSECT
SELECT [Enterprise.Project].prjLoc
FROM [Enterprise.Project];

-- Query 15 : What are the numbers of work hours for all possible combinations of employees and then projects? (Hints: This is an OLAP query using GROUP BY CUBE. Work hours canNOT be NULL. The results should be sorted by the employee SSNs then the project ids.)

SELECT [Enterprise.Work].empSSN, [Enterprise.Work].prjId, SUM ([Enterprise.Work].hours) AS 'Work Hours'
FROM [Enterprise.Work]
GROUP BY CUBE ([Enterprise.Work].empSSN, [Enterprise.Work].prjId)
HAVING SUM([Enterprise.Work].hours) > 0
ORDER BY [Enterprise.Work].empSSN,[Enterprise.Work].prjId
