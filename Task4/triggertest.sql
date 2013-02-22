INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA222'); -- Ska funka eftersom 123 läst ELA111 detta testar RequiredCourse
INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA111'); -- ska ej läggas in eftersom 123 redan läst kursen
INSERT INTO Registrations(Student, courses) VALUES (111, 'MVE111'); -- ska ej funka redan registrerad
INSERT INTO Registrations(Student, courses) VALUES (999, 'TDA416'); -- ska bli registrerad
INSERT INTO Registrations(Student, courses) VALUES (666, 'TDA416'); -- hamna i väntelista
INSERT INTO Registrations(Student, courses) VALUES (777, 'TDA416'); -- hamna i väntelitsa
INSERT INTO Registrations(Student, courses) VALUES (777, 'MVE111'); -- bli registrerad
INSERT INTO Registrations(Student, courses) VALUES (777, 'MVE111'); -- Exception: "Student is already registered to the course"
INSERT INTO Registrations(Student, courses) VALUES (111, 'DAT111'); -- Exception: "Student has already passed the course"


DELETE --222 should be unregisterd from course and 666 should be registred
FROM Registrations r
WHERE r.student = '222'
AND r.courses = 'TDA416'

DELETE -- nothing should happen
FROM Registrations r
WHERE r.student = '999'
AND r.courses = 'MVE333'

DELETE -- 111 should not be waiting for tda999 any more
FROM Registrations r
WHERE r.student = 111
AND r.courses = 'TDA999'

DELETE -- 123 should be unregistered from course TDA999 and 333 should be registred
FROM REGISTRATIONS
WHERE r.student = 123
AND r.courses = 'TDA999'