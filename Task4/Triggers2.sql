CREATE OR REPLACE TRIGGER RegAtStudent
INSTEAD OF INSERT ON Registrations
REFERENCING NEW AS new
FOR EACH ROW
DECLARE 
	requiredCourse INT;
	passedRequiredCourse INT;
	ReadCurrentCourse  INT;
	alreadyRegistred INT;
	NbrOfPlacesInCourse INT;
	nbrOfRegistredInCourse INT;
	
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
	WHERE R.Courses = :new.Courses --vfr?
	AND R.Status = 'registered'
	AND R.Student = :new.student;
	
	SELECT Count(*)
	INTO NbrOfPlacesInCourse
	FROM LimitedParticipantsCourse L
	WHERE L.course = :new.Courses;
	
	SELECT COUNT (*)
	INTO nbrOfRegistredInCourse
	FROM Registrations R
	WHERE R.Courses = :new.Courses
	AND R.Status = 'registered';
	
	IF NbrOfPlacesInCourse
	
	IF requiredCourse = passedRequiredCourse THEN
		IF readCurrentCourse < 1 THEN
			IF alreadyRegistred < 1 THEN
				IF NbrOfPlacesInCourse > nbrOfRegistredInCourse THEN
					INSERT INTO Registred
					VALUES (:new.Student, :new.Courses);
				ELSE 
					INSERT INTO WaitingFor
					VALUES (:new.student, :new.Courses, current_TIMESTAMP);
				END IF;
			END IF;
		END IF;
	END IF;
END;

INSERT INTO Registrations(Student, courses) VALUES (123, 'TDA999');
INSERT INTO Registrations(Student, courses) VALUES (123, 'ELA111');

/*

vad jag ska checka! när en student registrerar sig!
läst alla "requires" kurser?
har läst kursen tidigare?
är registrerad sedan tidigare


är kursen full? limitedParticipantsCourse alltså platsen befintlig?
väntelista?

hamna på väntelistan!

*/


