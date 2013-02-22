INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA222'); -- Ska funka eftersom 123 läst ELA111 detta testar RequiredCourse
INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA111'); -- ska ej läggas in eftersom 123 redan läst kursen
INSERT INTO Registrations(Student, courses) VALUES (111, 'MVE111'); -- ska ej funka redan registrerad
INSERT INTO Registrations(Student, courses) VALUES (999, 'TDA416'); -- ska bli registrerad
INSERT INTO Registrations(Student, courses) VALUES (666, 'TDA416'); -- hamna i väntelista
INSERT INTO Registrations(Student, courses) VALUES (777, 'TDA416'); -- hamna i väntelitsa
INSERT INTO Registrations(Student, courses) VALUES (777, 'MVE111'); -- bli registrerad
INSERT INTO Registrations(Student, courses) VALUES (777, 'MVE111'); -- Exception: "Student has already passed the course"
