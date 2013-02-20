Group 23
Anton Palmqvist
Tomas Sellden



INSERT INTO Departments
VALUES ('Smurfen');
INSERT INTO Departments
VALUES ('Kalle Anka');
INSERT INTO Departments
VALUES ('MatteHuset');


INSERT INTO Programs
VALUES ('IT');
INSERT INTO Programs
VALUES ('Elektro');
INSERT INTO Programs
VALUES ('Datateknik');
INSERT INTO Programs
VALUES ('Matte');


INSERT INTO HostProgram
VALUES ('IT', 'Smurfen');
INSERT INTO HostProgram
VALUES ('Datateknik', 'Smurfen');
INSERT INTO HostProgram
VALUES ('Elektro', 'Kalle Anka');
INSERT INTO HostProgram
VALUES ('Matte', 'MatteHuset');


INSERT INTO Students
VALUES (123, 'Tomas Sellden', 'IT');
INSERT INTO Students
VALUES (234, 'Jocke Persson', 'IT');
INSERT INTO Students
VALUES (345, 'Alexandra Johansson', 'IT');
INSERT INTO Students
VALUES (456, 'Erika hej', 'IT');
INSERT INTO Students
VALUES (111, 'Anton Palmqvist', 'Datateknik');
INSERT INTO Students
VALUES (222, 'Elisabeth Johansson', 'Datateknik');
INSERT INTO Students
VALUES (999, 'Hans Modig', 'Datateknik');
INSERT INTO Students
VALUES (000, 'Evert Karlsson', 'Datateknik');
INSERT INTO Students
VALUES (333, 'Adam Johansson', 'Elektro');
INSERT INTO Students
VALUES (567, 'Tomten Johansson', 'Elektro');
INSERT INTO Students
VALUES (678, 'Ulla Anke', 'Elektro');
INSERT INTO Students
VALUES (444, 'Gilbert Robinsson', 'Elektro');
INSERT INTO Students
VALUES (555, 'Johan Brooke', 'Matte');
INSERT INTO Students 
VALUES (666, 'Andreas Rolen', 'Matte');
INSERT INTO Students 
VALUES (777, 'Kalle Glad', 'Matte');
INSERT INTO Students 
VALUES (888, 'Nils Munter', 'Matte');


INSERT INTO Branches
VALUES ('Algoritmer', 'IT');
INSERT INTO Branches
VALUES ('Java', 'IT');
INSERT INTO Branches
VALUES ('Java', 'Datateknik');
INSERT INTO Branches
VALUES ('MAC', 'Datateknik');
INSERT INTO Branches
VALUES ('Lampor', 'Elektro');
INSERT INTO Branches
VALUES ('el', 'Elektro');
INSERT INTO Branches
VALUES ('Kryptografi', 'Matte');
INSERT INTO Branches
VALUES ('Algoritmer', 'Matte');


INSERT INTO Courses
VALUES ('TDA357', 'Databaser', 7.5, 'Smurfen');
INSERT INTO Courses
VALUES ('TDA416', 'Datastrukter', 10, 'Smurfen');
INSERT INTO Courses
VALUES ('TDA111', 'Android', 10, 'Smurfen');
INSERT INTO Courses
VALUES ('DAT111', 'kretsar', 10, 'Smurfen');
INSERT INTO Courses
VALUES ('DAT222', 'hardvara', 10, 'Smurfen');
INSERT INTO Courses
VALUES ('DAT333', 'datorteknik', 10, 'Smurfen');
INSERT INTO Courses
VALUES ('MVE111', 'Analys', 5, 'MatteHuset');
INSERT INTO Courses
VALUES ('MVE222', 'Diskret', 7.5, 'MatteHuset');
INSERT INTO Courses
VALUES ('MVE333', 'Statistik', 10, 'MatteHuset');
INSERT INTO Courses
VALUES ('ELA111', 'Retorik', 5, 'Kalle Anka');
INSERT INTO Courses
VALUES ('ELA222', 'Retorik2', 5, 'Kalle Anka');
INSERT INTO Courses
VALUES ('ELA333', 'ellara', 7.5, 'Kalle Anka');

INSERT INTO Courses
VALUES ('TDA999', 'Datorer', 7.5, 'Smurfen');


INSERT INTO ProgMandatoryCourse
VALUES ('Elektro', 'ELA111');
INSERT INTO ProgMandatoryCourse
VALUES ('IT', 'TDA357');
INSERT INTO ProgMandatoryCourse
VALUES ('IT', 'TDA111');
INSERT INTO ProgMandatoryCourse
VALUES ('Matte', 'MVE111');
INSERT INTO ProgMandatoryCourse
VALUES ('Datateknik', 'DAT111');

INSERT INTO Orientations
VALUES (123, 'Java', 'IT');
INSERT INTO Orientations
VALUES (222, 'Java', 'Datateknik');
INSERT INTO Orientations
VALUES (888, 'Algoritmer', 'Matte');
INSERT INTO Orientations
VALUES (555, 'Kryptografi', 'Matte');
INSERT INTO Orientations
VALUES (567, 'Lampor', 'Elektro');
INSERT INTO Orientations
VALUES (111, 'MAC', 'Datateknik');

INSERT INTO Registred
VALUES (222, 'TDA416');
INSERT INTO Registred
VALUES (111, 'MVE111');
INSERT INTO Registred
VALUES (444, 'ELA111');
INSERT INTO Registred
VALUES (333, 'TDA416');
INSERT INTO Registred
VALUES (111, 'TDA357');


INSERT INTO HasRead
VALUES (111, 'TDA416', '5');
INSERT INTO HasRead
VALUES (222, 'TDA416', 'U');
INSERT INTO HasRead
VALUES (333, 'TDA357', '3');
INSERT INTO HasRead
VALUES (444, 'DAT222', '4');
INSERT INTO HasRead
VALUES (555, 'TDA416', 'U');
INSERT INTO HasRead
VALUES (666, 'MVE333', '5');
INSERT INTO HasRead
VALUES (111, 'TDA357', '5');
INSERT INTO HasRead
VALUES (111, 'DAT111', '5');
INSERT INTO HasRead
VALUES (123, 'ELA111', '5');
INSERT INTO HasRead
VALUES (123, 'DAT333', '5');
INSERT INTO HasRead
VALUES (123, 'TDA416', '5');

INSERT INTO HasRead
VALUES (111, 'MVE111', 5);
INSERT INTO HasRead
VALUES (111, 'MVE222', 5);
INSERT INTO HasRead
VALUES (111, 'MVE333', 5);





INSERT INTO WaitingFor
VALUES (111, 'TDA999', '2013-01-05 12:00:00');
INSERT INTO WaitingFor
VALUES (222, 'TDA999', '2013-01-06 11:00:00');
INSERT INTO WaitingFor
VALUES (333, 'TDA999', '2013-01-04 12:00:00');
INSERT INTO WaitingFor
VALUES (444, 'TDA999', '2013-02-14 12:00:00');
INSERT INTO WaitingFor
VALUES (555, 'TDA999', '2013-02-14 11:59:59');


INSERT INTO LimitedParticipantsCourse
VALUES ('TDA999', 5);
INSERT INTO LimitedParticipantsCourse
VALUES ('TDA416', 3);
INSERT INTO LimitedParticipantsCourse
VALUES ('MVE222', 4);
INSERT INTO LimitedParticipantsCourse
VALUES ('ELA333', 3);


INSERT INTO Requires
VALUES ('ELA222', 'ELA111');
INSERT INTO Requires
VALUES ('DAT111', 'DAT222');


INSERT INTO Classification
VALUES ('Mathematical');
INSERT INTO Classification
VALUES ('Research');
INSERT INTO Classification
VALUES ('Seminar');

INSERT INTO HasClassification
VALUES ('MVE333', 'Research');
INSERT INTO HasClassification
VALUES ('MVE111', 'Mathematical');
INSERT INTO HasClassification
VALUES ('MVE111', 'Seminar');
INSERT INTO HasClassification
VALUES ('MVE222', 'Mathematical');
INSERT INTO HasClassification
VALUES ('MVE333', 'Mathematical');
INSERT INTO HasClassification
VALUES ('DAT333', 'Research');
INSERT INTO HasClassification
VALUES ('ELA111', 'Seminar');
INSERT INTO HasClassification
VALUES ('ELA222', 'Seminar');


INSERT INTO Recommended
VALUES ('MVE111', 'MAC', 'Datateknik');
INSERT INTO Recommended
VALUES ('MVE333', 'MAC', 'Datateknik');
INSERT INTO Recommended
VALUES ('TDA111', 'Algoritmer', 'Matte');
INSERT INTO Recommended
VALUES ('ELA111', 'Java', 'IT');


INSERT INTO BranchMandatory
VALUES ('TDA416', 'Java', 'IT');
INSERT INTO BranchMandatory
VALUES ('ELA333', 'Kryptografi', 'Matte');
INSERT INTO BranchMandatory
VALUES ('DAT222', 'Lampor', 'Elektro');

