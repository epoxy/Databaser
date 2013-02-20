Group 23
Anton Palmqvist
Tomas Sellden




DROP VIEW StudentFollowing;
DROP VIEW FinishedCourses;
DROP VIEW Registrations;
DROP VIEW PassedCourses;
DROP VIEW CourseQueuePositions;
DROP VIEW PassedCourses;
DROP VIEW UnreadMandatory;
DROP VIEW PathToGraduation;

CREATE VIEW StudentFollowing AS
SELECT Students.name AS studentName, Students.program, NVL(Orientations.branch, 'No branch chosen') AS BRANCH
FROM Students 
LEFT OUTER JOIN 
Orientations 
ON Orientations.student = Students.id;

DESCRIBE StudentFollowing;

CREATE VIEW FinishedCourses AS
SELECT HasRead.student AS studentID, HasRead.course AS completedCourse, grade AS Grade, credit
FROM HasRead, Courses
WHERE HasRead.course = Courses.code
ORDER BY studentID;

DESCRIBE FinishedCourses;

CREATE VIEW Registrations AS
SELECT Registred.student AS Student, Registred.course AS Courses, 'registered' AS Status
FROM Registred
UNION
SELECT WaitingFor.student AS Student, WaitingFor.course AS Courses, 'waiting' AS Status
FROM WaitingFor
ORDER BY Student;

DESCRIBE Registrations;

CREATE VIEW CourseQueuePositions AS
SELECT w2.course AS Course, w2.student AS Student,
	(SELECT COUNT(*)
	 FROM WaitingFor w1  
	 WHERE w1.course = w2.course AND w1.queue <= w2.queue) AS QueueNumber
FROM WaitingFor w2
ORDER BY Course, QueueNumber;

DESCRIBE CourseQueuePositions;

CREATE VIEW PassedCourses AS
SELECT f.studentID AS StudentID, f.completedCourse AS PassedCourse, f.grade AS Grade, c.credit
FROM FinishedCourses f, Courses c
WHERE grade NOT IN 'U' AND f.completedCourse=c.code;

DESCRIBE PassedCourses;

CREATE VIEW UnreadMandatory AS
((SELECT Students.id AS StudentID, ProgMandatoryCourse.course AS MandatoryCourse
FROM Students, ProgmandatoryCourse
WHERE ProgMandatoryCourse.program = Students.program)
UNION
(SELECT Students.id AS StudentID, BranchMandatory.course AS MandatoryCourse
FROM Students, BranchMandatory
WHERE BranchMandatory.program = Students.program))
MINUS
(SELECT PassedCourses.StudentID AS StudentID, PassedCourses.PassedCourse AS MandatoryCourse
FROM PassedCourses);

DESCRIBE UnreadMandatory;

CREATE VIEW PathToGraduation AS
WITH
NumberOfCredits AS (SELECT s.id AS StudentID, NVL(SUM(pc.credit), 0) AS TotalCredit
FROM Students s LEFT OUTER JOIN PassedCourses pc
ON s.id = pc.StudentID
GROUP BY s.id),
NumberOfBranchMandatory AS (SELECT s.id AS StudentID, NVL(COUNT(um.MandatoryCourse), 0) AS MandatoryCoursesLeft
FROM Students s LEFT OUTER JOIN UnreadMandatory um
ON s.id = um.StudentID
GROUP BY s.id),
NumberOfRecommendedRead AS (SELECT S.id AS StudentID, NVL(SUM(credit), 0) AS RecommendedCourseCreditTaken
FROM Recommended R JOIN Orientations O
ON R.branch = O.branch
AND R.program = O.program
JOIN PassedCourses PC
ON PC.StudentID = O.Student
AND R.course = PC.PassedCourse
RIGHT OUTER JOIN Students S
ON PC.studentID = S.id
GROUP BY S.id),
NumberOfMathPoints AS (SELECT S.id AS StudentID, NVL(SUM(PC.credit), 0) AS NbrOfMathCredits
FROM PassedCourses PC JOIN HasClassification HC
ON PC.PassedCourse = HC.course
AND HC.Classification='Mathematical'
RIGHT OUTER JOIN Students S
ON PC.StudentID = S.id
GROUP BY S.id),
NumberOfResearchPoints AS (SELECT S.id AS StudentID, NVL(SUM(PC.credit), 0) AS NbrOfResearchCredits
FROM PassedCourses PC JOIN HasClassification HC
ON PC.PassedCourse = HC.course
AND HC.Classification='Research'
RIGHT OUTER JOIN Students S
ON PC.StudentID = S.id
GROUP BY S.id),
NumberOfSeminarPoints AS (SELECT S.id AS StudentID, NVL(COUNT(PC.credit), 0) AS NbrOfSeminarCredits
FROM PassedCourses PC JOIN HasClassification HC
ON PC.PassedCourse = HC.course
AND HC.Classification='Seminar'
RIGHT OUTER JOIN Students S
ON PC.StudentID = S.id
GROUP BY S.id),
Graduated AS (
SELECT Students.id AS StudentID, 
CASE 
	WHEN 
    NumberOfBranchMandatory.MandatoryCoursesLeft = 0 AND
	NumberOfRecommendedRead.RecommendedCourseCreditTaken > 10 AND
	NumberOfMathPoints.NbrOfMathCredits >= 20 AND
	NumberOfResearchPoints.NbrOfResearchCredits >= 10 AND
	NumberOfSeminarPoints.NbrOfSeminarCredits >= 1
THEN 'TRUE'
ELSE 'FALSE'
END AS IsGraduated
FROM Students
LEFT OUTER JOIN NumberOfBranchMandatory
ON NumberOfBranchMandatory.StudentID = Students.id
LEFT OUTER JOIN NumberOfRecommendedRead
ON NumberOfRecommendedRead.StudentID = Students.id
LEFT OUTER JOIN NumberOfMathPoints
ON NumberOfMathPoints.StudentID = Students.id
LEFT OUTER JOIN NumberOfResearchPoints
ON NumberOfResearchPoints.StudentID = Students.id
LEFT OUTER JOIN NumberOfSeminarPoints
ON NumberOfSeminarPoints.StudentID = Students.id)
 
SELECT Students.id AS StudentID, NumberOfCredits.TotalCredit, NumberOfBranchMandatory.MandatoryCoursesLeft, 
NumberOfRecommendedRead.RecommendedCourseCreditTaken, NumberOfMathPoints.NbrOfMathCredits, 
NumberOfResearchPoints.NbrOfResearchCredits, NumberOfSeminarPoints.NbrOfSeminarCredits, Graduated.IsGraduated
FROM Students, NumberOfCredits, NumberOfBranchMandatory, NumberOfRecommendedRead, NumberOfMathPoints, NumberOfResearchPoints, NumberOfSeminarPoints, Graduated
WHERE Students.id=NumberOfCredits.StudentID AND Students.id=NumberOfBranchMandatory.StudentID AND 
Students.id=NumberOfRecommendedRead.StudentID
AND Students.id=NumberOfMathPoints.StudentID AND Students.id=NumberOfResearchPoints.StudentID AND 
Students.id=NumberOfSeminarPoints.StudentID AND Students.id = Graduated.StudentID
ORDER BY Students.id



