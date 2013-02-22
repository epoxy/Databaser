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
	nbrOfStudentsInQueue INT;

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
	
	IF alreadyRegistred=0 AND alreadyWaiting=0 
	THEN
      raise_application_error (-20999,'Student not registered or waiting');
	END IF;

	SELECT Count(*)
	INTO IsaLimitedCourse
	FROM LimitedParticipantsCourse L
	WHERE L.course = :old.Courses;
	
	SELECT COUNT (*)
	INTO nbrOfRegistredInCourse
	FROM Registrations R
	WHERE R.Courses = :old.Courses
	AND R.Status = 'registered';

	SELECT COUNT(*)
	INTO nbrOfStudentsInQueue
	FROM CourseQueuePositions Q
	WHERE Q.Course = old.Courses;
	
	SELECT COUNT(*)
	INTO nbrOfStudentsInQueue
	FROM CourseQueuePositions Q
	WHERE Q.Course = old.Courses;
	
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

---- latest

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
	nbrOfStudentWaiting INT;

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
	
	SELECT COUNT (*)
	INTO nbrOfStudentWaiting
	FROM CourseQueuePositions Q
	WHERE q.Course = :old.courses;
	
	IF alreadyWaiting != 0 THEN	--sista satsen vi gör!
		DELETE
		FROM WaitingFor W
		WHERE W.Course = :old.courses
		AND W.student = :old.student;
	END IF;
	
	IF alreadyRegistred != 0 THEN -- kasta exception?
		DELETE
		FROM Registred R
		WHERE R.Course = :old.Courses
		AND R.student = :old.student;
	END IF;
	
	IF nbrOfStudentWaiting != 0 AND IsaLimitedCourse != 0 THEN 
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
			DELETE 
			FROM CourseQueuePositions q
			WHERE q.Course = :old.courses
			AND q.queueNumber = 1;					
		END IF;
	END IF;	
END;

DELETE 
FROM Registrations r
WHERE r.student = '222'
AND r.courses = 'TDA416'