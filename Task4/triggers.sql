  CREATE TRIGGER TryToRegister
  	AFTER INSERT ON 


CREATE ASSERTION AlreadyPassed
CHECK(NOT EXISTS
	(SELECT Registred.student student1, WaitingFor.student student2
	FROM Registred, WaitingFor
	WHERE student1=student1)
);

CREATE OR REPLACE TRIGGER UnRegStudent
INSTEAD OF DELETE ON Registrations
REFERENCING OLD AS old
FOR EACH ROW
DECLARE
	alreadyRegistred INT;
	alreadyWaiting INT;
	IsaLimitedCourse INT;
	nbrOfRegistredInCourse INT;
	nbrOfPlacesInCourse INT;
	registerStudent INT;

BEGIN
SELECT COUNT (*)
	INTO alreadyRegistred
	FROM Registrations R
	WHERE R.Courses = :old.Courses
	AND R.Status = 'registered'
	AND R.Student = :old.student;

SELECT COUNT (*)
	INTO alreadyWaiting
	FROM Registrations R
	WHERE R.Courses = :old.Courses
	AND R.Status = 'waiting'
	AND R.Student = :old.student;
	
	SELECT Count(*)
	INTO IsaLimitedCourse
	FROM LimitedParticipantsCourse L
	WHERE L.course = :old.Courses;
	
	SELECT COUNT (*)
	INTO nbrOfRegistredInCourse
	FROM Registrations R
	WHERE R.Courses = :old.Courses
	AND R.Status = 'registered';
	
	IF alreadyWaiting != 0 THEN	
	DELETE
	FROM Registrations R
	WHERE R.Courses = :old.courses
	AND R.student = :old.student;
	END IF;
	
	IF alreadyRegistred != 0 THEN
	DELETE
	FROM Registrations R
	WHERE R.Courses = :old.Courses
	AND R.student = :old.student;
	END IF;
	
	IF IsaLimitedCourse != 0 THEN
	SELECT L.availablePlaces
		INTO NbrOfPlacesInCourse
		FROM LimitedParticipantsCourse L
		WHERE L.course = :old.Courses;
		IF nbrOfRegistredInCourse < NbrOfPlacesInCourse THEN
			SELECT  q.student
			INTO registerStudent
			FROM CourseQueuePositions q
			WHERE q.Course = :old.courses
			AND q.queueNumber = 1;
			INSERT INTO Registred
			VALUES (registerStudent, :old.courses);
		END IF;
	END IF;
END;