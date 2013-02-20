Group 23
Anton Palmqvist
Tomas Sellden



begin
for c in (select table_name from user_tables) loop
execute immediate ('drop table '||c.table_name||' cascade constraints');
end loop;
end;
/
begin
for c in (select * from user_objects) loop
execute immediate ('drop '||c.object_type||' '||c.object_name);
end loop;
end;
/

CREATE TABLE Departments(
	name VARCHAR(70),
	PRIMARY KEY(name)
);

DESCRIBE Departments;

CREATE TABLE Programs(
	name VARCHAR(50),
	PRIMARY KEY(name)
);

DESCRIBE Programs;

CREATE TABLE HostProgram(
	program VARCHAR(50),
	department VARCHAR(70),
	PRIMARY KEY(program, department),
	FOREIGN KEY(program) REFERENCES Programs(name),
	FOREIGN KEY(department) REFERENCES Departments(name)
);

DESCRIBE HostProgram;

CREATE TABLE Students(
	id INT,
	name VARCHAR(50),
	program VARCHAR(50),
	PRIMARY KEY(id),
	FOREIGN KEY(program) REFERENCES Programs(name),
	UNIQUE (id, program)
);
DESCRIBE Students;

CREATE TABLE Branches(
	name VARCHAR(50),
	program VARCHAR(50),
	PRIMARY KEY(name, program),
	FOREIGN KEY(program) REFERENCES Programs(name)

);
DESCRIBE Branches;

CREATE TABLE Courses(
	code CHAR(6),
	name VARCHAR(50),
	credit FLOAT CONSTRAINTS validCredit CHECK (credit > 0),
	department VARCHAR(70),
	PRIMARY KEY(code),
	FOREIGN KEY (department) REFERENCES Departments(name)
);

DESCRIBE Courses;

CREATE TABLE ProgMandatoryCourse(
	program VARCHAR(50),
	course CHAR(6), 
	PRIMARY KEY(program, course),
	FOREIGN KEY(program) REFERENCES Programs(name),
	FOREIGN KEY(course) REFERENCES Courses(code)
);

DESCRIBE ProgMandatoryCourse; 

CREATE TABLE Orientations(
	student INT,
	branch VARCHAR(50),
	program VARCHAR(50),
	PRIMARY KEY(student),
	FOREIGN KEY (branch, program) REFERENCES Branches(name, program),
	FOREIGN KEY (student, program) REFERENCES Students(id, program)
);

DESCRIBE Orientations;

CREATE TABLE Registred(
	student INT,
	course CHAR(6),
	PRIMARY KEY(student, course),
	FOREIGN KEY(student) REFERENCES Students(id),
	FOREIGN KEY(course) REFERENCES Courses(code)
);	
CREATE TABLE HasRead(
	student INT,
	course CHAR(6),
	grade CHAR(1), 
	PRIMARY KEY(student, course),
	FOREIGN KEY(student) REFERENCES Students(id),
	FOREIGN KEY(course) REFERENCES Courses(code),
	CONSTRAINTS validGrade CHECK (grade IN ('U', '3', '4', '5'))
);
DESCRIBE HasRead;

CREATE TABLE WaitingFor(
	student INT,
	course CHAR(6),
	queue TIMESTAMP,
	PRIMARY KEY(student, course),
	FOREIGN KEY(student) REFERENCES Students(id),
	FOREIGN KEY(course) REFERENCES Courses(code),
	UNIQUE(queue, course)
);
DESCRIBE WaitingFor;

CREATE TABLE LimitedParticipantsCourse(
	course CHAR(6),
	availablePlaces INT CONSTRAINTS LimitedParticipantsCourse CHECK (availablePlaces > 0),
	PRIMARY KEY(course),
	FOREIGN KEY(course) REFERENCES Courses(code)
);
DESCRIBE LimitedParticipantsCourse;

CREATE TABLE Requires(
	course CHAR(6),
	requiredCourse CHAR(6),
	PRIMARY KEY(course),
	FOREIGN KEY(course) REFERENCES Courses(code),
	FOREIGN KEY(requiredCourse) REFERENCES Courses(code)
);
DESCRIBE Requires;

CREATE TABLE Classification(
	type VARCHAR(50),
	PRIMARY KEY(type)
);
DESCRIBE Classification;

CREATE TABLE HasClassification(
	course CHAR(6),
	classification VARCHAR(50),
	PRIMARY KEY(course, classification),
	FOREIGN KEY(course) REFERENCES Courses(code),
	FOREIGN KEY(classification) REFERENCES Classification(type)
);
DESCRIBE HasClassification;

CREATE TABLE Recommended(
	course CHAR(6),
	branch VARCHAR(50),
	program VARCHAR(50),
	PRIMARY KEY(course, branch, program),
	FOREIGN KEY(course) REFERENCES Courses(code),
	FOREIGN KEY(branch, program) REFERENCES Branches(name, program)
);
DESCRIBE Recommended;

CREATE TABLE BranchMandatory(
	course CHAR(6),
	branch VARCHAR(50),
	program VARCHAR(50),
	PRIMARY KEY(course, branch, program),
	FOREIGN KEY(branch, program) REFERENCES Branches(name, program)
);	

DESCRIBE BranchMandatory;




	