INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA222'); -- should work since  123 already passed course ELA111 so he should be registred at course ELA222
INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA111'); -- Exception: "Student has already passed the course"
INSERT INTO Registrations(Student, courses) VALUES (999, 'TDA416'); -- 999 should be registred at course tda416
INSERT INTO Registrations(Student, courses) VALUES (666, 'TDA416'); -- 666 should be registred as waiting at course tda416
INSERT INTO Registrations(Student, courses) VALUES (777, 'TDA416'); -- 777 should be in registred as waiting at course tda416
INSERT INTO Registrations(Student, courses) VALUES (777, 'MVE111'); -- 777 should be registred at mve111
INSERT INTO Registrations(Student, courses) VALUES (777, 'MVE111'); -- Exception: "Exception: "Student is already registered to or waiting for the course"
INSERT INTO Registrations(Student, courses) VALUES (111, 'DAT111'); -- Exception: "Student has already passed the course"
INSERT INTO Registrations(Student, courses) VALUES (111, 'DAT111'); -- Exception: "Student hasn´t passed the required courses"


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