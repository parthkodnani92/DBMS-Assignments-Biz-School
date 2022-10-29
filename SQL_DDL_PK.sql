USE BUDT703_DB_Student_019;

ALTER TABLE [Terp.Employee]
DROP CONSTRAINT IF EXISTS fk_Employee_dptId;
DROP TABLE IF EXISTS [Terp.Dependent];
DROP TABLE IF EXISTS [Terp.Work];
DROP TABLE IF EXISTS [Terp.Project];
DROP TABLE IF EXISTS [Terp.DepartmentLocation];
DROP TABLE IF EXISTS [Terp.Department];
DROP TABLE IF EXISTS [Terp.Employee];

CREATE TABLE [Terp.Employee] (
	empSSN CHAR (9) NOT NULL,
	empFName VARCHAR (20),
	empMInit CHAR (1),
	empLName VARCHAR (20),
	empDOB DATE,
	empGender CHAR (1),
	empStreet VARCHAR (20),
	empCity VARCHAR (15),
	empState CHAR (2),
	empZipCODE CHAR (9),
	empSalary DECIMAL (10, 2),
	sprEmpSSN CHAR (9),
	dptId CHAR (3) NOT NULL,
	CONSTRAINT pk_Employee_empSSN PRIMARY KEY (empSSN),
	CONSTRAINT fk_Employee_sprEmpSSN FOREIGN KEY (sprEmpSSN)
		REFERENCES [Terp.Employee] (empSSN)
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [Terp.Department] (
	dptId CHAR (3) NOT NULL,
	dptName VARCHAR (20),
	mgrEmpSSN CHAR (9) NOT NULL,
	mgrStartDate DATE,
	CONSTRAINT pk_Department_dptId PRIMARY KEY (dptId),
	CONSTRAINT fk_Department_mgrEmpSSN FOREIGN KEY (mgrEmpSSN)
		REFERENCES [Terp.Employee] (empSSN)
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [Terp.DepartmentLocation] (
	dptId CHAR (3) NOT NULL,
	dptLoc VARCHAR (20) NOT NULL,
	CONSTRAINT pk_DepartmentLocation_dptId_dptLoc PRIMARY KEY (dptId, dptLoc),
	CONSTRAINT fk_DepartmentLocation_dptId FOREIGN KEY (dptId)
		REFERENCES [Terp.Department] (dptId)
		ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE [Terp.Project] (
	prjId CHAR (3) NOT NULL,
	prjName VARCHAR (20),
	prjLoc VARCHAR (15),
	dptId CHAR (3) NOT NULL,
	CONSTRAINT pk_Project_prjId PRIMARY KEY (prjId),
	CONSTRAINT fk_Project_dptId FOREIGN KEY (dptId)
		REFERENCES [Terp.Department] (dptId)
		ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE [Terp.Work] (
	empSSN CHAR (9) NOT NULL,
	prjId CHAR (3) NOT NULL,
	workHours FLOAT (10),
	CONSTRAINT pk_Work_empSSN_prjId PRIMARY KEY (empSSN, prjId),
	CONSTRAINT fk_Work_empSSN FOREIGN KEY (empSSN)
		REFERENCES [Terp.Employee] (empSSN)
		ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_Work_prjId FOREIGN KEY (prjId)
		REFERENCES [Terp.Project] (prjId)
		ON DELETE NO ACTION ON UPDATE NO ACTION,
);

CREATE TABLE [Terp.Dependent] (
	empSSN CHAR (9) NOT NULL,
	dpdName VARCHAR (20) NOT NULL,
	dpdDOB DATE,
	dpdGender CHAR (1),
	dpdRelationship VARCHAR (10),
	CONSTRAINT pk_Dependent_empSSN_dpdName PRIMARY KEY (empSSN, dpdName),
	CONSTRAINT fk_Dependent_empSSN FOREIGN KEY (empSSN)
		REFERENCES [Terp.Employee] (empSSN)
		ON DELETE CASCADE ON UPDATE CASCADE,
);

INSERT INTO [Terp.Employee] VALUES
	('000000001', 'Joe', 'Q', 'Rogan', '07/18/1999', 'M', '3417 Tulane Dr', 'Hyattsville', 'MD', '20783', 50000.00, NULL, 'D01');

INSERT INTO [Terp.Department] VALUES
	('D01', 'Administration', '000000001', '03/20/2020');

ALTER TABLE [Terp.Employee]
ADD CONSTRAINT fk_Employee_dptId FOREIGN KEY (dptId)
	REFERENCES [Terp.Department] (dptId)
	ON DELETE NO ACTION ON UPDATE NO ACTION;

INSERT INTO [Terp.DepartmentLocation] VALUES
	('D01', 'College Park');

INSERT INTO [Terp.Project] VALUES
	('P01', 'Data Analysis', 'College Park', 'D01');

INSERT INTO [Terp.Work]	VALUES
	('000000001', 'P01', '8.5');

INSERT INTO [Terp.Dependent] VALUES
	('000000001', 'Mary Rogan', '08/14/2001', 'F', 'Wife')


