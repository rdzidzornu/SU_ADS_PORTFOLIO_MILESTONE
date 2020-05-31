USE IST659CLASS;    -- This specifies the database we want to use for our project.
GO
CREATE SCHEMA Project  -- Created a Schema for the Project instead of using DEFAULT schema dbo
GO
-- Church Table
USE IST659CLASS;    -- This specifies the database we want to use for our project objects.
GO
-- check if table exists in INFORMATION_SCHEMA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Project.Church')
BEGIN
	DROP TABLE Project.Church;   -- If table exists, the table is DROPPED
END
GO
CREATE TABLE Project.Church(
	ChurchID Int Identity,
	ChurchName Varchar(50) NOT NULL,
	Address1 Varchar(50) NOT NULL,
	Address2 Varchar(50),
	City Varchar(25) NOT NULL,
	State Varchar(25) NOT NULL,
	ZipCode Varchar(10) NOT NULL,
	TelephoneNumber Varchar(25) NOT NULL,
	MinisterName Varchar(50) NOT NULL,
	BranchName AS (ChurchName +'-')+ City,  -- added a computed column
	CONSTRAINT UQ_City UNIQUE (City),
	CONSTRAINT PK_ChurchID PRIMARY KEY (ChurchID))

-- Role Table
IF OBJECT_ID (N'Project.Role', N'U') IS NOT NULL  -- Another approach of checking if table exists
	DROP TABLE Project.Role;  
GO
CREATE TABLE Project.Role(
	RoleID Int Identity,
	RoleName Varchar(25) NOT NULL,
	RoleDescription Varchar(50),
	CONSTRAINT UQ_Role UNIQUE(RoleName),
	CONSTRAINT PK_RoleID PRIMARY KEY (RoleID))

-- Person Table
IF OBJECT_ID (N'Project.Person', N'U') IS NOT NULL  -- Another approach of checking if table exists
	DROP TABLE Project.Person;  
GO
CREATE TABLE Project.Person(
	PersonID Int Identity,
	ChurchID Int,
	RoleID Int,
	FirstName Varchar(25) NOT NULL,
	LastName Varchar(25) NOT NULL,
	MiddleInitial Char,
	Gender Char NOT NULL,
	DateOfBirth Date NOT NULL,
	EmailAddress Varchar(50) NOT NULL,
	PhoneNumber Varchar(25) NULL,
	CONSTRAINT PK_PersonID PRIMARY KEY (PersonID),
	CONSTRAINT FK_Person_ChurchID FOREIGN KEY(ChurchID) REFERENCES Project.Church(ChurchID),
	CONSTRAINT FK_Person_RoleID FOREIGN KEY(RoleID) REFERENCES Project.Role(RoleID),
	CONSTRAINT UQ_Person_EmailID UNIQUE (EmailAddress))

-- added Default Constraint to Person table after noticing I omitted it
ALTER TABLE Project.Person
ADD CONSTRAINT  DF_PhoneNumber --Default Name as DF_PhoneNumber
DEFAULT 'xxx-xxx-xxxx' FOR PhoneNumber; -- xxx-xxx-xxxx being our default phone number

-- Ministry Table
IF OBJECT_ID (N'Project.Ministry', N'U') IS NOT NULL  -- Another approach of checking if table exists
	DROP TABLE Project.Ministry;  
GO
CREATE TABLE Project.Ministry(
	MinistryID Int Identity,
	MinistryName Varchar(50) NOT NULL,
	MinistryDescription Varchar(100),
	CONSTRAINT PK_MinistryID PRIMARY KEY (MinistryID))

-- Program Table
IF OBJECT_ID (N'Project.Program', N'U') IS NOT NULL  
	DROP TABLE Project.Program;  
GO
CREATE TABLE Project.Program(
	ProgramID Char(10) NOT NULL,
	MinistryID Int,
	ProgramName Varchar(50) NOT NULL,
	StartDateTime Datetime NOT NULL,
	EndDateTime Datetime NOT NULL,
	Description  Varchar(100) NULL,
	CONSTRAINT PK_ProgramID PRIMARY KEY (ProgramID),
	CONSTRAINT FK_Program_MinistryID FOREIGN KEY(MinistryID) REFERENCES Project.Ministry(MinistryID))

-- Classroom Table
IF OBJECT_ID (N'Project.Classroom', N'U') IS NOT NULL 
	DROP TABLE Project.Classroom;  
GO
CREATE TABLE Project.Classroom(
	ClassroomID Int Identity,
	ClassName Varchar(50) NOT NULL,
	RoomNumber Char(5) NOT NULL,
	StartDateTime Datetime NOT NULL,
	EndDateTime Datetime NOT NULL,
	LeadTeacher Varchar(50) NOT NULL,
	CONSTRAINT PK_ClassroomID PRIMARY KEY (ClassroomID))


-- Creating Bridge Tables(PersonMinistry, PersonProgram and ProgramClassroom)
--PersonMinistry Table
/* 
In creating the bridge table, i came to the realization that 
PersonMinistryID, PersonProgramID columns weren't necessary since they won't create
any unique identifier for the records. so I removed it from the 
table creation
*/

IF OBJECT_ID (N'Project.PersonMinistry', N'U') IS NOT NULL  
	DROP TABLE Project.PersonMinistry;  
GO
CREATE TABLE Project.PersonMinistry(
	PersonID Int NOT NULL,
	MinistryID Int NOT NULL,
	CONSTRAINT FK_PersonMin_PersonID FOREIGN KEY(PersonID) REFERENCES Project.Person(PersonID),
	CONSTRAINT FK_PersonMin_MinistryID FOREIGN KEY(MinistryID) REFERENCES Project.Ministry(MinistryID))

--PersonProgram Table
IF OBJECT_ID (N'Project.PersonProgram', N'U') IS NOT NULL
	DROP TABLE Project.PersonProgram;
GO
CREATE TABLE Project.PersonProgram(
	ProgramID Char(10) NOT NULL,
	PersonID Int NOT NULL,
	CONSTRAINT FK_PersonProg_ProgramID FOREIGN KEY(ProgramID) REFERENCES Project.Program(ProgramID),
	CONSTRAINT FK_PersonProg_PersonID FOREIGN KEY(PersonID) REFERENCES Project.Person(PersonID))

--ProgramClassroom Table
IF OBJECT_ID (N'Project.ProgramClassroom', N'U') IS NOT NULL
	DROP TABLE Project.ProgramClassroom;
GO
CREATE TABLE Project.ProgramClassroom(
	ProgramClassroomID Int Identity,
	ProgramID Char(10) NOT NULL,
	ClassroomID Int NOT NULL,
	CONSTRAINT FK_ProgramClass_ProgramID FOREIGN KEY(ProgramID) REFERENCES Project.Program(ProgramID),
	CONSTRAINT FK_ProgramClass_ClassroomID FOREIGN KEY(ClassroomID) REFERENCES Project.Classroom(ClassroomID))

/*
-- Creating Bridge Tables(PersonMinistry, PersonProgram and ProgramClassroom)
--PersonMinistry Table
IF OBJECT_ID (N'Project.PersonMinistry', N'U') IS NOT NULL  
	DROP TABLE Project.PersonMinistry;  
GO
/* 
In creating the bridge table, i came to the realization that 
PersonMinistryID column wasnt necessary since it won't create
any unique identity for the records. so I removed it from the 
table creation
*/
CREATE TABLE Project.PersonMinistry(
	PersonID Int NOT NULL,
	MinistryID Int NOT NULL,
	CONSTRAINT FK_PersonMin_PersonID FOREIGN KEY(PersonID) REFERENCES Project.Person(PersonID),
	CONSTRAINT FK_PersonMin_MinistryID FOREIGN KEY(MinistryID) REFERENCES Project.Ministry(MinistryID))

--PersonProgram Table
IF OBJECT_ID (N'Project.PersonProgram', N'U') IS NOT NULL
	DROP TABLE Project.PersonProgram;
GO
CREATE TABLE Project.PersonProgram(
	PersonProgramID Int Identity,
	ProgramID Char(10) NOT NULL,
	PersonID Int NOT NULL,
	CONSTRAINT FK_PersonProg_ProgramID FOREIGN KEY(ProgramID) REFERENCES Project.Program(ProgramID),
	CONSTRAINT FK_PersonProg_PersonID FOREIGN KEY(PersonID) REFERENCES Project.Person(PersonID))

--ProgramClassroom Table
IF OBJECT_ID (N'Project.ProgramClassroom', N'U') IS NOT NULL
	DROP TABLE Project.ProgramClassroom;
GO
CREATE TABLE Project.ProgramClassroom(
	ProgramClassroomID Int Identity,
	ProgramID Char(100) NOT NULL,
	ClassroomID Int NOT NULL,
	CONSTRAINT FK_ProgramClass_ProgramID FOREIGN KEY(ProgramID) REFERENCES Project.Program(ProgramID),
	CONSTRAINT FK_ProgramClass_ClassroomID FOREIGN KEY(ClassroomID) REFERENCES Project.Classroom(ClassroomID))
*/
	
/********************END OF TABLE CREATION IN "PROJECT" SCHEMA)*************************************************/

/********************BEGIN INSERT STATEMENTS********************************************************************/

--The following scripts are sample scripts used to insert records or data into the various tables created.

--Project.Church Table
INSERT INTO Project.Church(ChurchName, Address1, Address2, City, State, ZipCode, TelephoneNumber, MinisterName)
VALUES('Visitor', 'Visitor', 'Visitor', 'Visitor', 'Visitor', 'Visitor', 'Visitor', 'Visitor'),
	  ('Qodesh Family Church', '14801 Physicians Lane', NULL, 'Germantown', 'Maryland', '20874', '240-410-8457', 'Pastor Happy Kumah'),
	  ('Qodesh Family Church', '9104 Bakerhill Court', NULL, 'Gaithersburg', 'Maryland', '20886', '240-358-7953', 'Reverend David Forson'),
      ('Qodesh Family Church', '5440 Old Tucker Row', NULL, 'Columbia', 'Maryland', '21044', '443-561-9904', 'Pastor Angel Kumah'),
	  ('First Love Church', '5200 Perring Parkway', 'Morgan State University', 'Baltimore City', 'Maryland', '21214', '347-621-9159', 'Reverend Greggory Block'),
	  ('First Love Church', '2094 North Warwick Avenue', 'Copping State University', 'Baltimore', 'Maryland', '21214', '410-568-2152', 'Lady Pastor Sarah Woods'),
	  ('Qodesh Family Church', '7954A Twist Lane', NULL, 'Springfield', 'Virginia', '22153', '703-652-2015', 'Pastor Darlene Singar'),
	  ('First Love Church', '4400 University Drive', 'George Mason University', 'Faifax', 'Virginia', '22030', '615-331-5169', 'Reverend Anthony Kobi'),
	  ('First Love Church', '1100 Eastern Blvd. N', NULL, 'Hagerstown', 'Maryland', '21742', '258-587-6582', 'Reverend Edem Ameko'),
	  ('Qodesh Family Church', '1136 Centerville Turnpike North', NULL, 'Virginia Beach', 'Virginia', '23320', '757-698-1052', 'Lady Pastor Daniella Ray'),
      ('Qodesh Family Church', '350 White Horse Avenue', NULL, 'Trenton', 'New Jersey', '8610', '609-556-5854', 'Pastor William Mensa'),
	  ('First Love Church', '1625 Ocean Avenue', NULL, 'Brooklyn', 'New York', '11226', '347-251-3215', 'Pastor Jerry Johnson'),
	  ('Qodesh Family Church', '568 Bay Street', NULL, 'Staten Island', 'Staton Island', '10304', '718-987-1252', 'Lady Pastor Francisca Timber'),
      ('Qodesh Family Church', '126 Washington Avenue', NULL, 'Bridgeport', 'Connecticut', '6604', '917-632-5485', 'Pastor Nana Dankwah'),
	  ('Qodesh Family Church', '384 Wilshire Boulevard', NULL, 'Casselberry', 'Florida', '32707', '410-251-1212', 'Pastor George Williams'),
	  ('First Love Church', '150 West University Boulevard', NULL, 'Melbourne', 'Florida',  '32901', '410-067-1042', 'Reverend Richard Tori'),
      ('Qodesh Family Church', '321 Edgewater Drive', NULL, 'Orlando', 'Florida', '32804', '757-842-3698', 'Lady Pastor Faustina Gonyoe')

-- I noted a spelling error for the CITY Fairfax. Originally as Faifax
UPDATE Project.Church
SET CITY = 'Fairfax'  -- correct CITY name
WHERE ChurchID = 8

-- The following UPDATES were also made to correct the spelling of REVERAND in the MinistryName Column
--Reverand David Forson
UPDATE Project.Church
SET MinisterName = 'Reverend David Forson'  -- correct Minister's title 
WHERE ChurchID = 3

--Reverand Greggory Block
UPDATE Project.Church
SET MinisterName = 'Reverend Greggory Block'  -- correct Minister's title 
WHERE ChurchID = 5

--Reverand Anthony Kobi
UPDATE Project.Church
SET MinisterName = 'Reverend Anthony Kobi'  -- correct Minister's title 
WHERE ChurchID = 8

--Reverand Edem Ameko
UPDATE Project.Church
SET MinisterName = 'Reverend Edem Ameko'  -- correct Minister's title 
WHERE ChurchID = 9

--Reverand Richard Tori
UPDATE Project.Church
SET MinisterName = 'Reverend Richard Tori'  -- correct Minister's title 
WHERE ChurchID = 16

/*
I decided to create a view for the Outreach Team for them to be able to follow up on visitors
*/
CREATE VIEW Project.vw_VisitorsDetails
AS 
	SELECT
		R.RoleName,
		P.FirstName,
		P.LastName,
		P.Gender, 
		P.EmailAddress,
		P.PhoneNumber
	FROM Project.Church AS C
	INNER JOIN Project.Person AS P
	ON P.ChurchID = C.ChurchID
	INNER JOIN Project.Role AS R
	ON P.RoleID = R.RoleID
	WHERE R.RoleID = 6;   -- the roleid represents visitors.

-- the view 
SELECT * FROM Project.vw_VisitorsDetails;

Drop View Project.vw_VisitorsDetails;  -- Drop view anytime I want from the system

--Project.Role Table
INSERT INTO Project.Role(RoleName, RoleDescription)
VALUES('Minister', 'Spiritual Leader of the Church'), ('Worker', 'Employee of the Church'), 
		('Pastor', 'Trained Spiritual Leader Associated to the Church'), ('Shepherd', 'Leader of a Ministry'), 
		('Member', 'Person affiliated to the Church'), ('Visitor', 'Person Looking for a Place of Worship')

--Project.Person Table
INSERT INTO Project.Person(ChurchID, RoleID, FirstName, LastName, MiddleInitial, Gender, DateOfBirth, EmailAddress)
VALUES	(2, 1, 'Happy', 'Kumah', NULL, 'M', 	'10-29-1971', 'happy.kumah@qgc.org'), 
		(2, 5, 'Justin', 'King', NULL, 'M', 	'03-14-1990', 'justin.king@gmail.com'),
		(2,	5,	'Lily', 'Robertson',	NULL,	'F',	'12-28-1965',	'lily.robertson@gmail.com'),
		(2,	4,	'Nathan',	'Mackay',  'D',	'M',	'02-12-1990',	'nathan.mackay@hotmail.com'),
		(2,	5,	'Amanda',	'Rutherford',	'L',	'F',	'05-15-1981',	'amanda.rutherford@yahoo.com'),
		(2,	4,	'Alison',	'Wilkins',	NULL,	'F',	'09-21-1977',	'alison.wilkins@gmail.com'),
		(5,	5,	'Joseph',	'Lambert',	'T',	'M',	'03-01-1989',	'joseph.lambert@gmail.com'),
		(2,	5,	'Carl',	'Cornish',	NULL,	'M',	'07-24-2000',	'carl.cornish@gmail.com'),
		(2, 5, 'Stella', 'Mollis', 'A', 'F', '03-07-1973', 'non.quam@duis.ca'),
		(2,	5,	'Frank',	'Buckland',	NULL,	'M',	'07-23-1956',	'frank.buckland@gmail.com'),
		(2,	5,	'Greg',	'Black',	'O',	'M',	'04-13-1952',	'greg.black@hotmail.com'),
		(2,	5,	'Richard',	'Dowd',	'P',	'M',	'08-15-1952',	'richard.dowd@gmail.com'),
		(2, 5, 'Xaviera', 'Ferris', 'A', 'F', '04-01-1979', 'ferris@tricessit.org'),
		(2, 5, 'Raphael', 'Maphael', 'R', 'F', '07-27-2000', 'aenean.massa@mattis.co.uk'),
		(2,	5,	'Thomas',	'Terry',	NULL,	'M',	'05-30-1999',	'thomas.terry@yahoo.com'),
		(2,	4,	'Ian',	'Underwood',	'F',	'M',	'11-09-1991',	'ian.underwood@gmail.com'),
		(2,	5,	'Dylan',	'MacLeod',	'R',	'M',	'06-22-2005',	'dylan.macleod@hotmail.com'),
		(2,	3,	'Hannah',	'Metcalfe',	NULL,	'F',	'12-03-1986',	'hannah.metcalfe@gmail.com'),
		(2,	5,	'Thomas',	'May',	NULL,	'M',	'05-27-1988',	'thomas.may@gmail.com'),
		(6,	5,	'Boris',	'Buckland',	'G',	'M',	'10-08-2002',	'boris.buckland@yahoo.com'),
		(12, 3,	'Andrea',	'Terry',	'K',	'F',	'07-18-1980',	'andrea.terry@gmail.com'),
		(7, 5, 'Lydia', 'Posuere', 'L', 'F', '05-16-2000', 'dmagnis@Quisque.co.uk'),
		(5, 5, 'Keelie', 'Aliquam', 'N', 'F', '07-16-1999', 'keelie.Cras@sedorci.edu'),
		(2, 4, 'Jade', 'Sheila', 'V', 'F', '01-04-2001', 'magnis.dis@eu.net'),
		(2, 5, 'Shana', 'Perry', 'U', 'F', '07-23-1977', 'vestibulum@etpunc.net'),
		(2, 3, 'Fiona', 'Nam', 'A', 'F', '12-05-1981', 'ante.ipsum@nonquam.com'),
		(2, 5, 'Kiona', 'Elliott', 'F', 'F', '01-13-1969', 'orci.quis@massaru.ca'),		
		(5, 5, 'Vivian', 'Vernon', 'R', 'F', '07/12/1954', 'vivian.Vernon@yahoo.com'),
		(1, 6, 'Grace', 'Xantha', 'V', 'F', '12/31/1950', 'grace.magna@celement.co.uk'),
		(2, 5, 'Sarate', 'Ray', NULL, 'F', '11/04/1950', 'Sarate.Ray@gmail.com'),
		(2,	5,	'Samantha',	'Brown',	'J',	'F',	'12-26-1974',	'samantha.brown@yahoo.com'),
		(2,	5,	'Virginia',	'Nolan',	'Y',	'F',	'01-17-1993',	'virginia.nolan@gmail.com'),
		(2,	5,	'Victoria',	'Peters',	NULL,	'F',	'11-30-1964',	'victoria.peters@yahoo.com'),
		(2,	2,	'Stewart',	'Martin',	'H',	'M',	'09-07-1995',	'stewart.martin@gmail.com'),
		(2,	5,	'Ryan',	'Smith',	'M',	'M',	'06-04-1976',	'ryan.smith@gmail.com'),
		(2, 5, 'Irene', 'Aliquam', 'Z', 'F', '11/20/1998', 'aliquam@Gurabitur.net'),
		(2, 5, 'Rhona', 'Mattis', NULL, 'F', '09/25/2005', 'egestas.a.dui@mattisCras.edu'),
		(2, 1, 'Anne', 'Ornare', 'C', 'F', '02/28/1971', 'nulla.magna@natibus.com'),
		(2, 5, 'Sara', 'Kane', 'D', 'F', '01/04/1999', 'sara.ultrices@ornare.edu'),
		(1, 6, 'Ariel','Tempus','W', 'F', '10/27/1987', 'ariel.tempus@vitaesodalesat.com'),
		(2, 5, 'Francesca', 'Laciia', 'C', 'F', '05/30/1994', 'molestie.Sed@sagittis.com'),
		(3, 3, 'Uma', 'Pellentesque', 'N', 'F', '09/03/2003', 'amet.orci@mentumdui.net'),
		(2, 4, 'Venus', 'Curabitur', 'A', 'F', '03/18/1970', 'dolor.sit@Phasellus.org'),
		(1, 6, 'Leah', 'Dolor', 'K', 'F', '05/19/1986', 'rutrum@luctusetultrices.com'),
		(1, 6, 'Ori', 'Maxwells', NULL, 'F', '12/13/2001', 'arcu.Vivamus.sit@eget.org'),
		(2,	5,	'Dorothy',	'Springer',	'J',	'F',	'08-14-2003',	'dorothy.springer@gmail.com'),
		(8,	5,	'Caroline',	'Wright',	'V',	'F',	'05-22-1984',	'caroline.wright@hotmail.com'),
		(2,	5,	'Victor',	'Piper',	'N',	'M',	'04-16-1982',	'victor.piper@gmail.com'),
		(2,	5,	'Michael',	'Hamilton',	NULL,	'M',	'03-30-1998',	'michael.hamilton@gmail.com'),
		(2,	5,	'Tim',	'Peake',	NULL,	'M',	'12-31-1997',	'tim.peake@yahoo.com'),
		(2,	5,	'Fiona',	'Davidson',	'S',	'F',	'01-02-1979',	'fiona.davidson@gmail.com'),
		(2,	5,	'Brandon',	'King',	NULL,	'M',	'08-18-2001',	'brandon.king@gmail.com'),
		(4,	2,	'Matt',	'Glover',	NULL,	'M',	'05-23-1999',	'matt.glover@yahoo.com'),
		(2,	5,	'Jack',	'Lambert',	NULL,	'M',	'02-25-1976',	'jack.lambert@gmail.com'),
		(2, 5, 'Martha', 'Xenos', 'T', 'F', '07/23/1971', 'placerat.orci@egetvonare.com'),
		(2, 5, 'Renee', 'Richards', 'J', 'F','09/28/1985', 'ullam.corper@mhasellus.net'),
		(2, 5, 'Yael', 'Oprah', 'R', 'F', '06/24/1975', 'part.montes@eleifend.com'),
		(2, 5, 'Venus', 'Thor', 'A', 'F', '01/09/1999', 'ligula@urnasuscipit.com'),
		(5, 5, 'Gail', 'Chancellor', 'E', 'F', '01/06/1971', 'gail.chancellor@jersey.edu'),
		(5, 2, 'Shea', 'Dolor', NULL, 'F', '07/17/1976', 'semper.rat@hasel.com'),
		(1, 6, 'Dai', 'Fringilla', 'C', 'F', '12/25/1997', 'ringilla@aenean.edu'),
		(2, 4, 'Rylee', 'Stevenson', 'M', 'F', '02/23/1998', 'rylee.nisi@esttempor.edu'),
		(1, 6, 'Amena', 'Lesley', 'C', 'F', '07/22/1985', 'auctor.nisl@pede.com'),
		(2,	3,	'Alison',	'Mackenzie',	'W',	'F',	'02-28-1969',	'alison.mackenzie@hotmail.com'),
		(2,	5,	'Rebecca',	'Ferguson',	NULL,	'F',	'07-10-1973',	'rebecca.ferguson@gmail.com'),
		(2,	5,	'Nathan',	'Abraham',	NULL,	'M',	'06-08-2004',	'nathan.abraham@gmail.com'),
		(2,	4,	'Keith',	'Parsons',	'A',	'M',	'09-19-1994',	'keith.parsons@yahoo.com'),
		(2,	5,	'Virginia',	'Kerr',	NULL,	'F',	'11-20-1998',	'virginia.kerr@yahoo.com'),
		(2,	4,	'Samantha',	'Burgess',	'S',	'F',	'10-11-1980',	'samantha.burgess@gmail.com'),
		(2,	4,	'Zoe',	'Nolan',	NULL,	'F',	'03-29-1989',	'zoe.nolan@gmail.com'),
		(2, 5, 'Cara', 'Pooles', NULL, 'F', '11/04/2007', 'Cara.Pooles@fuscequam.co.uk'),
		(2,	5,	'Melanie',	'Powellson',	NULL,	'F',	'09-22-2005',	'melanie.Powellson@yahoo.com'),
		(2,	5,	'Joshua',	'Dicken',	'T',	'M',	'11-17-2005',	'joshua.dicken@gmail.com'),
		(2,	5,	'Alexander',	'Gills',	'D',	'M',	'01-12-2003',	'alexander.s@yahoo.com'),
		(4, 4, 'Emerald', 'Libero', 'L', 'F', '11/16/1987', 'euismod@sagittissemper.org'),
		(2, 1, 'Maggie', 'Laith', 'N', 'F', '10/15/1984', 'molestie.tellus@lobor.edu'),
		(1, 6, 'Miriam', 'Lael', 'E', 'F', '04/29/2014', 'cursus.non@pellentesque.ca'),
		(1, 6, 'Brenna', 'Sociis', 'A', 'F', '02/28/2000', 'lectus.call@tellusid.edu'),
		(5, 1, 'Karina', 'Arden','T','F','04/22/1974','fusce@tellusnonmagna.ca'),
		(2,	5,	'Alexander',	'Baileys',	'D',	'M',	'01-12-2003',	'alexander.baileys@yahoo.com'),
		(2,	5,	'David',	'Bucklands',	NULL,	'M',	'07-23-2006',	'david.bucklands@gmail.com'),
		(2,	5,	'Dominic',	'Blackson',	'O',	'M',	'04-13-2005',	'dominic.blackson@hotmail.com'),
		(2,	5,	'John',	'Dowd',	'P',	'M',	'08-15-2007',	'John.dowd@gmail.com'),
		(2, 5, 'Riley', 'Bradley', 'P', 'F', '07/31/1997', 'fermentum@euenim.org'),
		(5, 5, 'Evelyn', 'Elmo', 'S', 'F', '10/20/2000', 'auctor.velit@fusce.edu'),
		(5, 5, 'Hanae', 'Davis', 'N', 'F', '05/23/1976', 'davi.hanae@nuncsed.com'),
		(1, 6, 'Ashely', 'Felis', 'D', 'F', '09/10/1986', 'nullam.ashley@dumciis.com'),
		(4, 5, 'Aileen', 'Nisi', 'R', 'F', '02/10/2000', 'consequat.lectus@sociis.edu'),
		(2,	5,	'Pippa',	'Peters',	'H',	'M',	'11-01-1978',	'pippa.peters@hotmail.com'),
		(2,	5,	'Gordon',	'Gill',	'P',	'M',	'09-17-1997',	'gordon.gill@gmail.com'),
		(2,	5,	'Alexandra',	'Russell',	NULL,	'F',	'05-12-1985',	'alexandra.russell@gmail.com'),
		(2,	5,	'Benjamin',	'Underwood',	NULL,	'M',	'05-15-1975',	'benjamin.underwood@yahoo.com'),
		(2,	5,	'Evan',	'McGrath',	'B',	'M',	'07-27-1977',	'evan.mcgrath@gmail.com'),
		(3, 5, 'Lareina', 'Nissim', 'P', 'F', '05/12/1998', 'quis.pede@nullavul.edu'),
		(4, 5, 'Charity', 'Deirdre', 'H', 'F', '04/15/1993', 'cras@sagittisa.ca'),
		(4, 5, 'Carol',  'Lee', 'V', 'F', '09/28/1986', 'commodo@ipsumdolor.net'),
		(2, 5, 'Hope', 'Shafira', 'M', 'F', '09/12/2001', 'donec.feugiat@odio.edu'),
		(2,	5,	'David',	'Thomsons',	NULL,	'M',	'07-23-2006',	'david.Thomsons@gmail.com'),
		(2,	5,	'Dominic',	'White',	'O',	'M',	'04-13-2005',	'dominic.White@hotmail.com'),
		(2,	5,	'John',	'Dowdson',	'P',	'M',	'08-15-2007',	'John.dowdson@gmail.com'),
		(2, 4, 'Cara', 'Raymonds', NULL, 'F', '11/04/1972', 'non.luctus@fuscequam.co.uk'),
		(2,	5,	'Stephanie',	'Warts',	NULL,	'F',	'09-22-1953',	'Stephanie.warts@yahoo.com'),
		(2,	5,	'James',	'Dickson',	'T',	'M',	'11-17-1954',	'James.dickson@gmail.com'),
		(4, 5, 'Belle', 'Cums', 'J', 'F', '09/03/1953', 'belle.cums@hotmail.com'),
		(2,	5,	'Melanie',	'Watson',	NULL,	'F',	'09-22-1993',	'melanie.watson@yahoo.com'),
		(2,	5,	'Joshua',	'Dickens',	'T',	'M',	'11-17-2000',	'joshua.dickens@gmail.com'),
		(2,	5,	'Alexander',	'Bailey',	'D',	'M',	'01-12-1982',	'alexander.bailey@yahoo.com'),
		(2,	5,	'David',	'Buckland',	NULL,	'M',	'07-23-1976',	'david.buckland@gmail.com'),
		(2,	5,	'Dominic',	'Black',	'O',	'M',	'04-13-1992',	'dominic.black@hotmail.com'),
		(2,	4,	'Nathan',	'Dowd',	'P',	'M',	'08-15-1972',	'nathan.dowd@gmail.com'),
		(5, 5, 'Ila', 'Vernon', 'R', 'F', '07/12/1974', 'Ila.Vernon@sedsemegestas.net'),
		(1, 6, 'Inga', 'Xantha', 'V', 'F', '12/31/1990', 'Xantha.magna@celement.co.uk'),
		(2, 5, 'Sara', 'Raymondson', NULL, 'F', '11/04/2007', 'Sara.Raymondson@gmail.com'),
		(2,	5,	'Stephanie',	'Watsons',	NULL,	'F',	'09-22-2005',	'Stephanie.watsons@yahoo.com'),
		(2,	5,	'James',	'Dickenson',	'T',	'M',	'11-17-2005',	'James.dickenson@gmail.com'),
		(4, 5, 'Belle', 'Cum', 'J', 'F', '09/03/1998', 'pede.ut@auctorodioa.org'),
		(6, 5, 'Signe', 'Lee', 'C', 'F', '03/15/1970', 'ligula.Lee@sitametluctus.ca'),
		(1, 6, 'Kylynn', 'Sapton', 'J', 'F', '05/20/2000', 'sagittis.augue@qraesent.edu'),
		(2,	5,	'Theresa',	'Thomson',	NULL,	'F',	'12-12-1966',	'theresa.thomson@gmail.com'),
		(2,	5,	'Andrew',	'Gill',	NULL,	'M',	'08-03-1997',	'andrew.gill@gmail.com'),
		(6, 5, 'Signe', 'Leeson', 'C', 'F', '03/15/1956', 'ligula.Leeson@gmail.com'),
		(1, 6, 'Lynn', 'Sapton', 'J', 'F', '05/20/1950', 'lynn.sapton@syr.edu'),
		(2,	5,	'Theresa',	'Johnson',	NULL,	'F',	'12-12-1958',	'theresa.johnson@gmail.com'),
		(2,	5,	'Joseph',	'Powell',	'O',	'M',	'06-05-1978',	'joseph.powell@yahoo.com'),
		(2,	5,	'Karen',	'Poole',	'Z',	'F',	'05-20-1982',	'karen.poole@yahoo.com'),
		(2, 5, 'Cailin', 'Ipsum', NULL, 'F', '10/12/2001', 'arcu.civamus@nonquam.net'),
		(2, 5, 'Cara', 'Raymondson', NULL, 'F', '11/04/2007', 'Cara.Raymondson@fuscequam.co.uk'),
		(2,	5,	'Melanie',	'Watsons',	NULL,	'F',	'09-22-2005',	'melanie.watsons@yahoo.com'),
		(2,	5,	'Joshua',	'Dickenson',	'T',	'M',	'11-17-2005',	'joshua.dickenson@gmail.com')



--Project.Ministry Table
INSERT INTO Project.Ministry(MinistryName, MinistryDescription)
VALUES('Youth Development', 'Ministry for youth Developing. Age Group 13-17'), ('Mens', 'Ministry for Solely Men and is focused on Men Related Issues'),
		('Womens', 'Ministry for Solely Women and focused on Women Related Issues'), ('Marriage & Family', 'Ministry for Developing and Supporting Good Marraiges'),
		('Outreach', 'Ministry for reaching out to others'), ('Prayer Support', 'Prayer works Ministry. Pray and Support Others with Prayer'), 
		('Senior Adults', 'Ministry for Senior Citizens'), ('Young Adults', 'Ministry for Individuals in their 20s or Singles'),
		('Divorce Care', 'Ministry for Supporting People going through Divorce'), ('Music & Worship','Ministry for Praise and Worship')
		
--Project.Program Table
INSERT INTO Project.Program(ProgramID, MinistryID, ProgramName, StartDateTime, EndDateTime)
VALUES	('1-YD-0001', 1, 'Elevate Night', '01-12-2019 18:45:00', '01-12-2019 20:30:00'),
		('2-MM-0001', 2, 'Iron Sharpening Iron', '01/27/2018 21:00:00', '01/27/2018 22:45:00'),
		('3-WW-0001', 3, 'Every Woman"s Grace', '01/30/2018 18:30:00', '01/30/2018 20:00:00'),
		('4-MF-0001', 4, 'The Healthy Blended Family', '01/14/2018 14:45:00', '01/14/2018 14:15:00'),
		('5-OO-0001', 5, 'Frederick Rescue Mission', '01/05/2018 09:00:00', '01/05/2018 18:30:00'),
		('6-PS-0001', 6, 'Prayer Support', '01/12/2018 06:00:00', '01/12/2018 07:30:00'),
		('7-SA-0001', 7, 'Serious Fitness', '01/19/2018 09:00:00', '01/19/2018 10:45:00'),
		('8-YA-0001', 8, 'Young Adults Worship Night', '01/20/2018 21:15:00', '01/14/2018 22:45:00'),
		('9-DC-0001', 9, 'Divorce Care', '01/26/2018 19:00:00', '01/26/2018 20:15:00'),
		('1-YD-0002', 1, 'Weekend Youth Services', '02/04/2018 11:00:00', '02/04/2018 11:30:00'),
		('2-MM-0002', 2, 'Iron Sharpening Iron', '02/10/2018 21:00:00', '02/10/2018 22:45:00'),
		('3-WW-0002', 3, 'Every Woman"s Grace', '02/14/2018 18:30:00', '02/14/2018 20:00:00'),
		('4-MF-0002', 4, 'Making the Most of your Marriage', '02/21/2018 10:45:00', '02/21/2018 12:15:00'),
		('5-OO-0002', 5, 'Frederick Rescue Mission', '02/23/2018 09:00:00', '02/23/2018 18:30:00'),
		('6-PS-0002', 6, 'Prayer Support', '02/23/2018 06:00:00', '02/23/2018 07:30:00'),
		('7-SA-7002', 7, 'Jesus-Sight & Sound Theatres Trip', '02/28/2018 08:00:00', '02/28/2018 21:30:00'),
		('8-YA-0002', 8, 'Young Adults Worship Night', '02/17/2018 21:15:00', '01/28/2018 22:45:00'),
		('9-DC-0002', 9, 'Divorce Care', '02/23/2018 19:00:00', '02/23/2018 20:15:00')

		SELECT * FROM Project.Ministry

		--(1, 'Weeked Youth Services', '01/07/2018 11:00:00', '01/07/2018 11:30:00'),
		--(1, 'Weeked Youth Services', '01/14/2018 11:00:00', '01/14/2018 11:30:00'),
		--(1, 'Weeked Youth Services', '01/21/2018 11:00:00', '01/21/2018 11:30:00'),
		--(1, 'Weeked Youth Services', '01/28/2018 11:00:00', '01/28/2018 11:30:00'),
		--(2, 'Iron Sharpening Iron', '01/13/2018 21:00:00', '01/13/2018 22:45:00'),
		--(3, 'Every Woman"s Grace', '01/03/2018 18:30:00', '01/03/2018 20:00:00'),
		--(3, 'Every Woman"s Grace', '01/10/2018 18:30:00', '01/10/2018 20:00:00'),
		--(3, 'Every Woman"s Grace', '01/17/2018 18:30:00', '01/17/2018 20:00:00'),
		--(3, 'Every Woman"s Grace', '01/24/2018 18:30:00', '01/24/2018 20:00:00'),
		--(4, 'Making the Most of your Marriage', '01/07/2018 10:45:00', '01/07/2018 12:15:00'),
		--(6, 'Prayer Support', '01/05/2018 06:00:00', '01/05/2018 07:30:00'),
		--(6, 'Prayer Support', '01/19/2018 06:00:00', '01/19/2018 07:30:00'),
		--(6, 'Prayer Support', '01/26/2018 06:00:00', '01/26/2018 07:30:00'),
		--(7, 'Serious Fitness', '01/05/2018 09:00:00', '01/05/2018 10:45:00'),
		--(7, 'Serious Fitness', '01/12/2018 09:00:00', '01/12/2018 10:45:00'),
		--(7, 'Serious Fitness', '01/26/2018 09:00:00', '01/26/2018 10:45:00'),
		--(8, 'Young Adults Worship Night', '01/06/2018 21:15:00', '01/07/2018 22:45:00'),
		--(1, 'Weeked Youth Services', '02/11/2018 11:00:00', '02/11/2018 11:30:00'),
		--(1, 'Weeked Youth Services', '02/18/2018 11:00:00', '02/18/2018 11:30:00'),
		--(1, 'Weeked Youth Services', '02/25/2018 11:00:00', '02/25/2018 11:30:00'),
		--(2, 'Iron Sharpening Iron', '02/24/2018 21:00:00', '02/24/2018 22:45:00'),
		--(3, 'Every Woman"s Grace', '02/07/2018 18:30:00', '02/07/2018 20:00:00'),
		--(3, 'Every Woman"s Grace', '02/21/2018 18:30:00', '02/21/2018 20:00:00'),
		--(3, 'Every Woman"s Grace', '02/28/2018 18:30:00', '02/28/2018 20:00:00'),
		--(4, 'The Healthy Blended Family', '02/28/2018 12:45:00', '02/28/2018 14:15:00'),
		--(6, 'Prayer Support', '02/02/2018 06:00:00', '02/02/2018 07:30:00'),
		--(6, 'Prayer Support', '02/09/2018 06:00:00', '02/09/2018 07:30:00'),
		--(6, 'Prayer Support', '02/16/2018 06:00:00', '02/16/2018 07:30:00'),
		--(7, 'Serious Fitness', '02/02/2018 09:00:00', '02/02/2018 10:45:00'),
		--(7, 'Serious Fitness', '02/09/2018 09:00:00', '02/09/2018 10:45:00'),
		--(7, 'Serious Fitness', '02/16/2018 09:00:00', '02/16/2018 10:45:00'),
		--(7, 'Serious Fitness', '02/23/2018 09:00:00', '02/23/2018 10:45:00'),
		--(8, 'Young Adults Worship Night', '02/03/2018 21:15:00', '01/21/2018 22:45:00'),

		--Project.Classroom Table
INSERT INTO Project.Classroom(ClassName, RoomNumber, StartDateTime, EndDateTime, LeadTeacher) --ClassName reps the name of the ProgramName  for that moment
VALUES	('Elevate Night', 'Z056', '01-12-2019 18:45:00', '01-12-2019 20:30:00', 'Nathan Mackay'),
		('Iron Sharpening Iron', 'T858', '01/27/2018 21:00:00', '01/27/2018 22:45:00', 'Nathan Dowd'),
		('Every Woman"s Grace', 'E746', '01/30/2018 18:30:00', '01/30/2018 20:00:00', 'Cara Raymonds'),
		('The Healthy Blended Family',  'Q813', '01/14/2018 14:45:00', '01/14/2018 14:15:00', 'Venus Curabitur'),
		('Frederick Rescue Mission', 'C813', '01/05/2018 09:00:00', '01/05/2018 18:30:00', 'Samantha Burgess'),
		('Prayer Support', 'E746', '01/12/2018 06:00:00', '01/12/2018 07:30:00', 'Cara Raymonds'),
		('Serious Fitness', 'Z056', '01/19/2018 09:00:00', '01/19/2018 10:45:00', 'Zoe Nolan'),
		('Young Adults Worship Night', 'K159', '01/20/2018 21:15:00', '01/14/2018 22:45:00', 'Nathan Mackay'),
		('Divorce Care', 'T858', '01/26/2018 19:00:00', '01/26/2018 20:15:00', 'Alison Wilkins'),
		('Weekend Youth Services', 'Z056', '02/04/2018 11:00:00', '02/04/2018 11:30:00', 'Keith Parsons'),
		('Iron Sharpening Iron', 'T858', '02/10/2018 21:00:00', '02/10/2018 22:45:00', 'Nathan Dowd'),
		('Every Woman"s Grace', 'E746', '02/14/2018 18:30:00', '02/14/2018 20:00:00', 'Cara Raymonds'),
		('Making the Most of your Marriage',  'Q813', '02/21/2018 10:45:00', '02/21/2018 12:15:00', 'Venus Curabitur'),
		('Frederick Rescue Mission', 'C813', '02/23/2018 09:00:00', '02/23/2018 18:30:00', 'Samantha Burgess'),
		('Prayer Support', 'E746', '02/23/2018 06:00:00', '02/23/2018 07:30:00', 'Cara Raymonds'),
		('Jesus-Sight & Sound Theatres Trip', 'K159', '02/28/2018 08:00:00', '02/28/2018 21:30:00', 'Zoe Nolan'),
		('Young Adults Worship Night', 'K159', '02/17/2018 21:15:00', '01/28/2018 22:45:00', 'Nathan Mackay'),
		('Divorce Care', 'T858', '02/23/2018 19:00:00', '02/23/2018 20:15:00', 'Alison Wilkins')
		
	/*	('Divorce Care', 'T858', '02/23/2018 19:00:00', '02/23/2018 20:15:00', 'Alison Wilkins'),
		('Young Adults Worship Night', 'Z056', '02/03/2018 21:15:00', '01/21/2018 22:45:00', 'Nathan Mackay'),
		('Young Adults Worship Night', 'K159', '02/17/2018 21:15:00', '01/28/2018 22:45:00', 'Nathan Mackay'),
		('Prayer Support', 'E746', '02/02/2018 06:00:00', '02/02/2018 07:30:00', 'Cara Raymonds'),
		('Prayer Support', 'E746', '02/09/2018 06:00:00', '02/09/2018 07:30:00', 'Cara Raymonds'),
		('Prayer Support', 'E746', '02/16/2018 06:00:00', '02/16/2018 07:30:00', 'Cara Raymonds'),
		('Prayer Support', 'E746', '02/23/2018 06:00:00', '02/23/2018 07:30:00', 'Cara Raymonds'),
		('Making the Most of your Marriage', 'Q813', '02/21/2018 10:45:00', '02/21/2018 12:15:00', 'Venus Curabitur'),
		('The Healthy Blended Family', 'Q813', '02/28/2018 12:45:00', '02/28/2018 14:15:00', 'Venus Curabitur'),
		('Frederick Rescue Mission', 'C813', '02/23/2018 09:00:00', '02/23/2018 18:30:00', 'Samantha Burgess'),
		('Weeked Youth Services', 'Z056 ', '01/07/2018 11:00:00', '01/07/2018 11:30:00', 'Keith Parsons'),
		('Weeked Youth Services', 'Z056 ', '01/14/2018 11:00:00', '01/14/2018 11:30:00', 'Keith Parsons'),
		('Weeked Youth Services', 'K159', '01/21/2018 11:00:00', '01/21/2018 11:30:00', 'Keith Parsons'),
		('Weeked Youth Services', 'K159', '01/28/2018 11:00:00', '01/28/2018 11:30:00', 'Keith Parsons'),
		('Iron Sharpening Iron', 'T858', '01/13/2018 21:00:00', '01/13/2018 22:45:00', 'Nathan Dowd'),
		('Iron Sharpening Iron', 'K159', '01/27/2018 21:00:00', '01/27/2018 22:45:00', 'Nathan Dowd'),
		('Every Woman"s Grace', 'E746', '01/03/2018 18:30:00', '01/03/2018 20:00:00', 'Nathan Dowd'),
		('Every Woman"s Grace', 'E746', '01/10/2018 18:30:00', '01/10/2018 20:00:00', 'Nathan Dowd'),
		('Every Woman"s Grace', 'Z056', '01/17/2018 18:30:00', '01/17/2018 20:00:00', 'Nathan Dowd'),
		('Prayer Support', 'C813 ', '01/05/2018 06:00:00', '01/05/2018 07:30:00', 'Cara Raymonds'),
		('Prayer Support', 'C813 ', '01/12/2018 06:00:00', '01/12/2018 07:30:00', 'Cara Raymonds'),
		('Prayer Support', 'C813 ', '01/19/2018 06:00:00', '01/19/2018 07:30:00', 'Cara Raymonds'),
		('Prayer Support', 'C813 ', '01/26/2018 06:00:00', '01/26/2018 07:30:00', 'Cara Raymonds')
	*/



-- Inserting into Bridge Tables
-- Project.PersonMinistry
INSERT INTO Project.PersonMinistry(MinistryID, PersonID)
VALUES	(2, 1), (2, 2), (2, 4), (2, 7), (2, 10), (2, 11), (2, 12), (2, 16), (2, 19),(2, 35), (2, 35), 
		(2, 48), (2, 54), (2, 89), (2, 98), (2, 93), (2, 103), (2, 107), (2, 108), (2, 109), (2, 110), 
		(2, 124), (3, 5), (3, 6), (3, 9), (3, 13), (3, 18), (3, 21), (3, 25), (3, 26), (3, 27), (3, 31), 
		(3, 32), (3, 38), (3, 40), (3, 43), (3, 44), (3, 47), (3, 51), (3, 55), (3, 56), (3, 57), (3, 59),
		(3, 60), (3, 63), (3, 65), (3, 69), (3, 70), (3, 75), (3, 76), (3, 79), (3, 86), (3, 87), (3, 91),
		(3, 95), (3, 96), (3, 101), (3, 105), (3, 111), (3, 112), (3, 117), (3, 121), (3, 122), (3, 123), (3, 125)

-- Project.PersonProgram
INSERT INTO Project.PersonProgram(ProgramID, PersonID)
VALUES	('1-YD-0001', 34), ('1-YD-0001', 50), ('1-YD-0001',	49), ('1-YD-0001', 36), ('1-YD-0001', 53), ('1-YD-0001', 24), ('1-YD-0001', 42), 
		('1-YD-0001', 17), ('2-MM-0001', 108),('2-MM-0001', 124), ('2-MM-0001', 2), ('3-WW-0001', 122), ('3-WW-0001', 121), ('3-WW-0001', 69),
		('3-WW-0001', 69), ('4-MF-0001', 47), ('4-MF-0001', 91), ('4-MF-0001', 95), ('4-MF-0001', 32), ('5-OO-0001', 1), ('5-OO-0001', 59), ('5-OO-0001', 110)

--Project.ProgramClassroom
INSERT INTO Project.ProgramClassroom(ProgramID, ClassroomID)
VALUES('1-YD-0001', 1), ('2-MM-0001', 2), ('3-WW-0001', 3), ('4-MF-0001', 4), ('5-OO-0001', 5), ('6-PS-0001', 6), ('7-SA-0001', 7), ('8-YA-0001', 8), ('9-DC-0001', 9), 
	('1-YD-0002', 10), ('2-MM-0002', 11), ('3-WW-0002', 12), ('4-MF-0002', 13), ('5-OO-0002', 14), ('6-PS-0002', 15), ('7-SA-7002', 16), ('8-YA-0002', 17), ('9-DC-0002', 18)

	-- SELECT * FROM Project.Program	