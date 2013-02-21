  CREATE TRIGGER TryToRegister
  	AFTER INSERT ON 


CREATE ASSERTION AlreadyPassed
CHECK(NOT EXISTS
	(SELECT Registred.student student1, WaitingFor.student student2
	FROM Registred, WaitingFor
	WHERE student1=student1)
);