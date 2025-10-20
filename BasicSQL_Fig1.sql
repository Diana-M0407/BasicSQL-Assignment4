/*
Group Name: TuffyBase
Team Lead: Diana Maldonado: { di.maldonado5504@csu.fullerton.edu }
Group Members:
Dylan Morales: { d.morales7241@csu.fullerton.edu } Jordan Mai: { mai.monkey9@gmail.com }
Nikita Subedi: { 22subedin@csu.fullerton.edu } Steve Choi: { soondae@csu.fullerton.edu }
*/


/*
Write the following queries based on the database schema in Figure 1.

    1. Retrieve all course numbers and names, along with their prerequisite course numbers and names.
    2. Retrieve all course numbers and names for courses taught by Professor Anderson in 2007 and 2008.
    3. For each section taught by Professor Anderson, retrieve all course numbers, semesters, years, and the number of students enrolled in each section.
    4. Insert a new student, <’Johnson’, 25, 1, ‘Math’>, in the database.
    5. Insert a new course, <’Object Oriented Programming’,’CS1210’, 3, ‘CS’>, in the database
    6. Update the class of student ‘Smith’ to 3.
    7. Update the instructor for session 112 in Fall 2008 to King.
    8. Update Smith’s grade for class CS1310 in Fall 2008 to a B.
    9. Delete all sections taught by Prof. Stone.
    10. Remove the Discrete Mathematics prerequisite from a database course.
*/


/*
1. Retrieve all course numbers and names, along with their prerequisite course numbers and names.
*/
SELECT  c.course_no       AS course_no,
        c.title           AS course_title,
        p.prereq_no       AS prereq_no,
        cp.title          AS prereq_title
FROM PREREQUISITE p
JOIN COURSE c  ON c.course_no  = p.course_no
JOIN COURSE cp ON cp.course_no = p.prereq_no
ORDER BY c.course_no, p.prereq_no;


/*
2. Retrieve all course numbers and names, along with their prerequisite course numbers and names.
*/
SELECT DISTINCT c.course_no, c.title
FROM SECTION s
JOIN COURSE  c ON c.course_no = s.course_no
WHERE s.instructor = 'Anderson'
  AND s.year IN (2007, 2008);


/*
3. For each section taught by Professor Anderson, retrieve all course numbers, semesters, years, and the number of students enrolled in each section.
*/
SELECT  c.course_no,
        s.semester,
        s.year,
        s.section_id,
        COUNT(gr.student_id) AS num_students
FROM SECTION s
JOIN COURSE c    ON c.course_no = s.course_no
LEFT JOIN GRADE_REPORT gr ON gr.section_id = s.section_id   -- or ENROLL
WHERE s.instructor = 'Anderson'
GROUP BY c.course_no, s.semester, s.year, s.section_id
ORDER BY s.year, s.semester, c.course_no, s.section_id;

/* 
4. Insert a new student, <’Johnson’, 25, 1, ‘Math’>, in the database.
*/
INSERT INTO STUDENT (Name, Student_number, class, major)
VALUES ('Johnson', 25, 1, 'Math');

/* 
5. Insert a new course, <’Object Oriented Programming’,’CS1210’, 3, ‘CS’>, in the database
*/
INSERT INTO COURSE (Course_name, Course_number, Credit_hours, Department)
VALUES ('Object Oriented Programming', 'CS1210', 3, 'CS');

/* 
6. Update the class of student ‘Smith’ to 3.
*/
UPDATE STUDENT
SET Class = 3
WHERE Name = 'Smith';

/* 
7. Update the instructor for session 112 in Fall 2008 to King.
*/
UPDATE SECTION
SET Instructor = 'King'
WHERE Section_identifier = 112
  AND Semester = 'Fall'
  AND Year = 08;

/* 8 Update Smith’s grade for class CS1310 in Fall 2008 to a B.
*/
UPDATE GRADE_REPORT
		SET Grade = ‘B’
		WHERE Student_number = {
			SELECT Student_number
			FROM STUDENTS
			WHERE Name = ‘Smith’
		}
		AND Section_identifier = {
			SELECT Section_identifier
			FROM SECTION
			WHERE Course_number = 'CS1310'
			AND Semester = ‘Fall’
			AND Year = 08
		}

/* 9 Delete all sections taught by Prof. Stone.
*/
DELETE FROM SECTION
WHERE Instructor = 'Stone';