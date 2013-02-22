CREATE OR REPLACE TRIGGER RegAtStudent
INSTEAD OF INSERT ON Registrations
REFERENCING NEW AS new
FOR EACH ROW
DECLARE 
	requiredCourse INT;
	passedRequiredCourse INT;
	passedCurrentCourse INT;
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
	INTO passedCurrentCourse 
	FROM PassedCourses P
	WHERE P.passedCourse = :new.Courses
	AND P.StudentID = :new.student;

	IF passedCurrentCourse=1 
	THEN
      raise_application_error (-20000,'Student has already passed the course');
	END IF;
	
	SELECT COUNT (*)
	INTO alreadyRegistred
	FROM Registrations R
	WHERE R.Courses = :new.Courses
	AND R.Status = 'registered'
	AND R.Student = :new.student;
	
	IF alreadyRegistred=1 
	THEN
      raise_application_error (-20001,'Student is already registered to the course');
	END IF;

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
		IF passedCurrentCourse = 0 THEN
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
	END IF;	
END;
