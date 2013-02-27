import java.sql.*; // JDBC stuff.
import java.io.*;  // Reading user input.

public class StudentPortal
{
	/* This is the driving engine of the program. It parses the
	 * command-line arguments and calls the appropriate methods in
	 * the other classes.
	 *
	 * You should edit this file in two ways:
	 * 	1) 	Insert your database username and password (no @medic1!)
	 *		in the proper places.
	 *	2)	Implement the three functions getInformation, registerStudent
	 *		and unregisterStudent.
	 */
	
	/*
	 * Test cases:
	 * 1. Student: 111
	 * 2. Student: 123
	 * 3. Student: 123 Register: TDA357
	 * 4. Student: 123 Register: TDA357
	 * 5. Student: 123 Unregister: TDA357
	 * 6. Student: 123 Unregister: TDA357
	 * 7. Student: 222 Register: ELA222
	 * 8. Student: 222 Unregister: TDA999 -> Student 777 should be registered
	 * 9. Student: 222 Register: TDA999
	 * 10. Student: 222 Unregister
	 * 11. Student: 222 Unregister
	 * 12. TDA416 is overful
	 * 		Student: 777 Register: TDA416 -> is placed in queue
	 * 		Student: 555 Unregister: TDA416
	 */
	public static void main(String[] args)
	{
		if (args.length == 1) {
			try {
				DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
				String url = "jdbc:oracle:thin:@tycho.ita.chalmers.se:1521/kingu.ita.chalmers.se";
				String userName = "vtda357_023"; // Your username goes here!
				String password = "anton"; // Your password goes here!
				Connection conn = DriverManager.getConnection(url,userName,password);

				String student = args[0]; // This is the identifier for the student.
				BufferedReader input = new BufferedReader(new InputStreamReader(System.in));
				System.out.println("Welcome!");
				while(true) {
					System.out.println("Please choose a mode of operation:");
					System.out.print("? > ");
					String mode = input.readLine();
					if ((new String("information")).startsWith(mode.toLowerCase())) {
						/* Information mode */
						getInformation(conn, student);
					} else if ((new String("register")).startsWith(mode.toLowerCase())) {
						/* Register student mode */
						System.out.print("Register for what course? > ");
						String course = input.readLine();
						registerStudent(conn, student, course);
					} else if ((new String("unregister")).startsWith(mode.toLowerCase())) {
						/* Unregister student mode */
						System.out.print("Unregister from what course? > ");
						String course = input.readLine();
						unregisterStudent(conn, student, course);
					} else if ((new String("quit")).startsWith(mode.toLowerCase())) {
						System.out.println("Goodbye!");
						break;
					} else {
						System.out.println("Unknown argument, please choose either " +
								"information, register, unregister or quit!");
						continue;
					}
				}
				conn.close();
			} catch (SQLException e) {
				System.err.println(e);
				System.exit(2);
			} catch (IOException e) {
				System.err.println(e);
				System.exit(2);
			}
		} else {
			System.err.println("Wrong number of arguments");
			System.exit(3);
		}
	}

	static void getInformation(Connection conn, String student) throws SQLException
	{
		System.out.println("Information for student " + student +
				"\n-----------------------------");
		//Name, program and branch
		Statement infoStmt = conn.createStatement();
		ResultSet rs = infoStmt.executeQuery("SELECT studentName, program, branch " + 
				"FROM StudentFollowing " + 
				"WHERE studentId= '" + student + "'");
		rs.next();
		System.out.println("Name: " + rs.getString(1));
		System.out.println("Line: " + rs.getString(2));
		System.out.println("Branch: " + rs.getString(3));

		//Read Courses
		Statement readStmt = conn.createStatement();
		ResultSet rs3 = readStmt.executeQuery("SELECT name, completedCourse, Courses.credit, grade " +
				"FROM Courses, FinishedCourses " +
				"WHERE code=completedCourse AND studentID = '" + student + "'");
		System.out.println("\nRead courses (name (code), credits: grade):");
		while(rs3.next()){
			System.out.println("   " + rs3.getString(1) + " (" + 
					rs3.getString(2) + "), " + rs3.getString(3) + "p: " + rs3.getString(4));
		}

		//Registered Courses
		Statement regStmt = conn.createStatement();
		ResultSet rs4 = regStmt.executeQuery("SELECT Courses.name, Courses.code, Courses.credit, status " +
				"FROM Registrations, Courses " +
				"WHERE Courses.code=Registrations.courses AND " +
				"Registrations.student = '" + student + "'");
		System.out.println("\nRegistered courses (name (code), credits: status):");
		while(rs4.next()){
			System.out.println("   " + rs4.getString(1) + " (" + rs4.getString(2) + "), " + 
					rs4.getString(3) + "p: " + rs4.getString(4));

		}
		//Seminar courses taken
		Statement pathStmt = conn.createStatement();
		ResultSet rs5 = pathStmt.executeQuery("SELECT nbrOfSeminarCourses, nbrOfMathCredits, nbrOfResearchCredits, totalCredit, isGraduated " + 
				"FROM PathToGraduation " +
				"WHERE PathToGraduation.studentID = '" + student + "'");
		rs5.next();
		System.out.println("\nSeminar courses taken: " + rs5.getInt(1));
		System.out.println("Math credits taken: " + rs5.getInt(2));
		System.out.println("Research credits taken: " + rs5.getInt(3));
		System.out.println("Total credits taken: " + rs5.getInt(4));
		System.out.print("Fulfills the requirements for graduation: ");
		if(rs5.getString(5).equals("TRUE")){
			System.out.println("yes");
		}
		else{
			System.out.println("no");
		}
		System.out.println("-----------------------------\n");
	}

	static void registerStudent(Connection conn, String student, String course) throws SQLException
	{
		//Try to register
		try{
			Statement registerStmt = conn.createStatement();
			ResultSet rs1 = registerStmt.executeQuery("INSERT INTO Registrations(student, courses) " + 
					"VALUES (" + student + ", '" + course + "')");
			Statement successStmt = conn.createStatement();
			ResultSet rs2 = successStmt.executeQuery("SELECT name " + 
													"FROM Courses " + 
													"WHERE code = '" + course + "'");
			rs2.next();
			Statement regOrWaitStmt = conn.createStatement();
			ResultSet rs10 = regOrWaitStmt.executeQuery("SELECT status " +
														"FROM Registrations " +
														"WHERE Registrations.student = " + student + " " +
														"AND Registrations.courses = '" + course +"'");
			rs10.next();
			System.out.print("You are successfully " + rs10.getString(1) + " for course " + course + " " + rs2.getString(1));
			if(rs10.getString(1).equals("waiting")){
				Statement queueNrStmt = conn.createStatement();
				ResultSet rs11 = queueNrStmt.executeQuery("SELECT queuenumber " +
															"FROM Coursequeuepositions " +
															"WHERE Coursequeuepositions.student = " + student + " " +
															"AND Coursequeuepositions.course = '" + course +"'");
				rs11.next();
				System.out.print(", with queuenumber: " + rs11.getString(1));
			}
			System.out.println("\n");
		
		}
		catch(SQLException e){
			if(e.getErrorCode()==20001){ //Already registerd or waiting
				System.out.println("error 20001");
				Statement alreadyRegStmt = conn.createStatement();
				ResultSet rs3 = alreadyRegStmt.executeQuery("SELECT status " +
															"FROM Registrations " + 
															"WHERE Registrations.student = " + student + " " + 
															"AND Registrations.courses = '" + course + "'");
				rs3.next();
				System.out.println(rs3.getString(1));
				if(rs3.getString(1).equals("registered")){
					System.out.println("You are already registered for the course " + course);
				}
				else{
					System.out.println("You are already in the waitinglist for the course " + course);
				}
			}
			else if(e.getErrorCode()==20002){ //Already passed the course
				System.out.println("error 20002");
				System.out.println("You have already passed the course " + course);
			}
			else if(e.getErrorCode()==20003){ //Has not passed required courses
				System.out.println("error 20003");
				System.out.println("You have not passed the required courses for this course.");
			}
			else{
				System.out.println("Registration could NOT be done. Check information if the " +
						"course is already registered or waiting for.");
				System.out.println("Error code: " + e.getErrorCode());
			}
		}
	}

	static void unregisterStudent(Connection conn, String student, String course) throws SQLException
	
	{
		Statement isRegStmt = conn.createStatement();
		ResultSet rs1 = isRegStmt.executeQuery("SELECT COUNT(*) " +
												"FROM Registrations " +
												"WHERE Registrations.student = " + student + 
												" AND Registrations.courses = '" + course + "'");
		rs1.next();
		if (!(rs1.getString(1).equals("0"))) {//If registered or waiting for the course
		Statement unregStmt = conn.createStatement();
		ResultSet r2 = unregStmt.executeQuery("DELETE " +
											"FROM Registrations " +
											"WHERE Registrations.student = " + student + 
											" AND Registrations.courses = '" + course + "'");
		
		System.out.println("Student: " + student + " is now unregistred" +
				" from course: " + course);
		}
		else {
			System.out.println("Student: " + student + " was not registred at" +
					" this course and he is not registred now either at " + course);
		}
	}
}
