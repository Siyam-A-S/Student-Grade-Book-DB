-- Number 4, Compute the average/highest/lowest score of an assignment;
select a.AssignmentID, avg(s.POINTS), max(s.POINTS), min(s.POINTS) from ASSIGNMENT a, SCORE s where a.AssignmentID=2 AND s.AssignmentID=a.AssignmentID;

-- Number 5, List all students of a given course
select s.FirstName from STUDENT s where s.StudentID in (select e.StudentID from ENROLLMENT e where e.CourseID=85675);
select s.StudentID, s.FirstName from STUDENT s JOIN ENROLLMENT e where e.CourseID = 85675 and s.StudentID = e.StudentID;

-- Number 6: List all of the students in a course and all of their scores on every assignment
SELECT s.FirstName, s.LastName, a.AssignmentID, sc.POINTS
FROM STUDENT s
JOIN ENROLLMENT e ON s.StudentID = e.StudentID
JOIN COURSE c ON e.CourseID = c.CourseID
LEFT JOIN SCORE sc ON s.StudentID = sc.StudentID
LEFT JOIN ASSIGNMENT a ON sc.AssignmentID = a.AssignmentID
WHERE c.CourseID = 85675;

-- 7 Add an assignment to an course
INSERT INTO `ASSIGNMENT` VALUES(41, 20, 2, 100);

-- 8 Change the percentages of the categories for a course
UPDATE DISTRIBUTION
SET Percentage = 30
WHERE DistributionID = 1;


-- 9 Add 2 points to the score of each student on an assignment;
SET SQL_SAFE_UPDATES = 0; -- to disable safe mode
UPDATE SCORE
SET POINTS = POINTS + 2
WHERE AssignmentID = 1;

-- 10 Add 2 points just to those students whose last name contains a ‘Q’.
UPDATE SCORE sc
JOIN STUDENT s ON sc.StudentID = s.StudentID
SET sc.POINTS = sc.POINTS + 2
WHERE s.LastName LIKE '%Q%';

-- 11 Compute the grade for a student;
SELECT 
    (TotalPoints / TotalPointsPossible) * 100 AS GradePercentage
FROM (
    SELECT 
        COALESCE(SUM(s.POINTS), 0) AS TotalPoints
    FROM 
        SCORE s
    JOIN 
        ASSIGNMENT a ON s.AssignmentID = a.AssignmentID
    JOIN 
        DISTRIBUTION d ON a.DistributionID = d.DistributionID
    JOIN 
        COURSE c ON d.CourseID = c.CourseID
    JOIN 
        ENROLLMENT e ON s.StudentID = e.StudentID
    WHERE 
        e.StudentID = 1234
    AND 
        c.CourseID = e.CourseID
) AS Total,
(
    SELECT 
        SUM(a.PointsPossible) AS TotalPointsPossible
    FROM 
        ASSIGNMENT a
    JOIN 
        DISTRIBUTION d ON a.DistributionID = d.DistributionID
    JOIN 
        COURSE c ON d.CourseID = c.CourseID
    JOIN 
        ENROLLMENT e ON c.CourseID = e.CourseID
    WHERE 
        e.StudentID = 1234
    AND 
        c.CourseID = e.CourseID
) AS TotalPossible;



--12 Compute the grade for a student, where the lowest score for a given category is dropped.
SELECT DISTINCT pt.StudentID, st.FirstName, st.LastName, pt.CourseID,pt.AssignmentID, pt.CategoryName, pt.Points, pt.PointsPossible, pt.Percentage
FROM (
    SELECT STUDENT.StudentID, AssignmentID, FirstName, LastName, CourseID, Points
    FROM STUDENT JOIN ENROLLMENT JOIN SCORE
    WHERE STUDENT.StudentID = ENROLLMENT.StudentID
    AND STUDENT.StudentID = SCORE.StudentID) st
JOIN
(SELECT StudentID, CourseID, CategoryName, ASSIGNMENT.AssignmentID, Points, ASSIGNMENT.PointsPossible, DISTRIBUTION.Percentage
    FROM DISTRIBUTION JOIN ASSIGNMENT JOIN SCORE
    WHERE DISTRIBUTION.DistributionID = ASSIGNMENT.DistributionID
    AND ASSIGNMENT.AssignmentID = SCORE.AssignmentID) pt
WHERE st.AssignmentID = pt.AssignmentID
AND st.Points = pt.Points AND st.StudentID=1234;