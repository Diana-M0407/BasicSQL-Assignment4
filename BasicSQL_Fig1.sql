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
SELECT  C.Course_number      AS CourseNumber,
        C.Course_name        AS CourseName,
        P.Prerequisite_number AS PrereqCourseNumber,
        C2.Course_name       AS PrereqCourseName
FROM PREREQUISITE P
JOIN COURSE C  ON C.Course_number  = P.Course_number
JOIN COURSE C2 ON C2.Course_number = P.Prerequisite_number
ORDER BY C.Course_number;


/*
2.Retrieve all course numbers and names for courses taught by Professor Anderson in 2007 and 2008.
*/
SELECT DISTINCT C.Course_number, C.Course_name
FROM COURSE C
JOIN SECTION S ON C.Course_number = S.Course_number
WHERE S.Instructor = 'Anderson'
  AND S.Year IN (2007, 2008);

/*
3. For each section taught by Professor Anderson, retrieve all course numbers, semesters, years, and the number of students enrolled in each section.
*/
SELECT  C.Course_number,
        S.Semester,
        S.Year,
        COUNT(G.Student_number) AS NumStudents
FROM SECTION S
JOIN COURSE C       ON C.Course_number = S.Course_number
LEFT JOIN GRADE_REPORT G ON G.Section_identifier = S.Section_identifier
WHERE S.Instructor = 'Anderson'
GROUP BY C.Course_number, S.Semester, S.Year
ORDER BY S.Year, S.Semester;


/* 
4. Insert a new student, <’Johnson’, 25, 1, ‘Math’>, in the database.
*/
INSERT INTO STUDENT (Name, Student_number, Class, Major)
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
  AND Year = 2008;

/* 
8. Update Smith’s grade for class CS1310 in Fall 2008 to a B.
*/
UPDATE GRADE_REPORT G
JOIN STUDENT S  ON S.Student_number = G.Student_number
JOIN SECTION Sec ON Sec.Section_identifier = G.Section_identifier
JOIN COURSE C  ON C.Course_number = Sec.Course_number
SET G.Grade = 'B'
WHERE S.Name = 'Smith'
  AND C.Course_number = 'CS1310'
  AND Sec.Semester = 'Fall'
  AND Sec.Year = 2008;




/* 
9. Delete all sections taught by Prof. Stone.
*/

DELETE FROM GRADE_REPORT
WHERE Section_identifier IN (
    SELECT Section_identifier
    FROM SECTION
    WHERE Instructor = 'Stone'
);

DELETE FROM SECTION
WHERE Instructor = 'Stone';



/*
10. Remove the Discrete Mathematics prerequisite from a database course.
*/

DELETE P
FROM PREREQUISITE P
JOIN COURSE C1 ON C1.Course_number = P.Course_number
JOIN COURSE C2 ON C2.Course_number = P.Prerequisite_number
WHERE C1.Course_name = 'Database'
  AND C2.Course_name = 'Discrete Mathematics';

