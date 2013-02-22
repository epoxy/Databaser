CREATE OR REPLACE TRIGGER RegAtStudent
INSTEAD OF INSERT ON Registrations
REFERENCING NEW AS new
FOR EACH ROW
DECLARE 
	requiredCourse INT;
	passedRequiredCourse INT;
	ReadCurrentCourse  INT;
	alreadyRegistred INT;
	IsaLimitedCourse INT;
	nbrOfRegistredInCourse INT;
	NbrOfPlacesInCourse INT;
	
	
BEGIN
	SELECT COUNT(*)
	INTO requiredCourse
	FROM Requires R
	WHERE R.course = :new.Courses;

	SELECT COUNT(*)
	INTO passedRequiredCourse
	FROM Requires R, PassedCourses P
	Where R.requiredCourse = P.passedCourse
	AND P.StudentID = :new.student
	AND R.Course = :new.Courses;
	
	SELECT COUNT (*)
	INTO ReadCurrentCourse
	FROM PassedCourses P
	WHERE P.passedCourse = :new.Courses
	AND P.StudentID = :new.student;
	
	SELECT COUNT (*)
	INTO alreadyRegistred
	FROM Registrations R
	WHERE R.Courses = :new.Courses
	AND R.Status = 'registered'
	AND R.Student = :new.student;
	
	SELECT Count(*)
	INTO IsaLimitedCourse
	FROM LimitedParticipantsCourse L
	WHERE L.course = :new.Courses;
	
	SELECT COUNT (*)
	INTO nbrOfRegistredInCourse
	FROM Registrations R
	WHERE R.Courses = :new.Courses
	AND R.Status = 'registered';
	

	
	IF requiredCourse = passedRequiredCourse THEN
		IF readCurrentCourse = 0 THEN
			IF alreadyRegistred = 0 THEN
				IF IsaLimitedCourse != 0 THEN
					SELECT L.availablePlaces
					INTO NbrOfPlacesInCourse
					FROM LimitedParticipantsCourse L
					WHERE L.course = :new.Courses;	
					IF nbrOfRegistredInCourse >= NbrOfPlacesInCourse THEN
						INSERT INTO WaitingFor
						VALUES (:new.student, :new.Courses, current_TIMESTAMP);	
					ELSE
						INSERT INTO Registred
						VALUES (:new.Student, :new.Courses);
				 	END IF;
				ELSE
				INSERT INTO Registred
				VALUES (:new.Student, :new.Courses);
				END IF;
			END IF;
		END IF;
	END IF;
END;

INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA222'); -- Ska funka eftersom 123 läst ELA111 detta testar RequiredCourse
INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA111'); -- ska ej läggas in eftersom 123 redan läst kursen
INSERT INTO Registrations(Student, courses) VALUES (111, 'MVE111'); -- ska ej funka redan registrerad
INSERT INTO Registrations(Student, courses) VALUES (999, 'TDA416'); -- ska bli registrerad
INSERT INTO Registrations(Student, courses) VALUES (666, 'TDA416'); -- hamna i väntelista
INSERT INTO Registrations(Student, courses) VALUES (777, 'TDA416'); -- hamna i väntelitsa
INSERT INTO Registrations(Student, courses) VALUES (777, 'MVE111'); -- bli registrerad



INSERT INTO Registrations(Student, courses) VALUES (123, 'TDA999');
INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA111');

CREATE OR REPLACE TRIGGER UnRegStudent
INSTEAD OF DELETE ON Registrations
REFERENCING NEW AS new
FOR EACH ROW
DECLARE
	alreadyRegistred INT;
	alreadyWaiting INT;
	IsaLimitedCourse INT;
	nbrOfRegistredInCourse;

BEGIN
SELECT COUNT (*)
	INTO alreadyRegistred
	FROM Registrations R
	WHERE R.Courses = :new.Courses
	AND R.Status = 'registered'
	AND R.Student = :new.student;

SELECT COUNT (*)
	INTO alreadyWaiting
	FROM Registrations R
	WHERE R.Courses = :new.Courses
	AND R.Status = 'waiting'
	AND R.Student = :new.student;
	
	SELECT Count(*)
	INTO IsaLimitedCourse
	FROM LimitedParticipantsCourse L
	WHERE L.course = :new.Courses;
	
	SELECT COUNT (*)
	INTO nbrOfRegistredInCourse
	FROM Registrations R
	WHERE R.Courses = :new.Courses
	AND R.Status = 'registered';
	
	IF alreadyWaiting != 0 THEN	
	DELETE
	FROM Registrations R
	WHERE R.Courses = :new.courses
	AND R.student = :new.student;
	END IF;
	
	IF alreadyRegistred != 0 THEN
	DELETE
	FROM Registrations R
	WHERE R.Course = :new.Courses
	AND R.student = :new.student;
	END IF
		IF IsaLimitedCourse != 0 THEN
		SELECT L.availablePlaces
			INTO NbrOfPlacesInCourse
			FROM LimitedParticipantsCourse L
			WHERE L.course = :new.Courses;	
			IF nbrOfRegistredInCourse < NbrOfPlacesInCourse THEN
				
			END IF;
		END IF;	
	END IF;
END;






/*

vad jag ska checka! när en student registrerar sig!
läst alla "requires" kurser?
har läst kursen tidigare?
är registrerad sedan tidigare


är kursen full? limitedParticipantsCourse alltså platsen befintlig?
väntelista?

hamna på väntelistan!

*/


