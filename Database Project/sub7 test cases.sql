Test case 1: List all courses and their scores for student with ID 5678:

SELECT c.CourseName, a.AssignmentID, s.POINTS
FROM COURSE c
JOIN ENROLLMENT e ON c.CourseID = e.CourseID
LEFT JOIN ASSIGNMENT a ON c.CourseID = a.DistributionID
LEFT JOIN SCORE s ON a.AssignmentID = s.AssignmentID AND e.StudentID = s.StudentID
WHERE e.StudentID = 5678;


Test case 2: Change the score of assignment ID 3 for student with ID 5678:

UPDATE SCORE
SET POINTS = 90
WHERE StudentID = 5678 AND AssignmentID = 3;


Test case 3: List all assignments and scores for student with ID 3456 in the course 'Introduction to Psychology':

SELECT a.AssignmentID, a.PointsPossible, s.POINTS
FROM ASSIGNMENT a
JOIN SCORE s ON a.AssignmentID = s.AssignmentID
JOIN ENROLLMENT e ON s.StudentID = e.StudentID
JOIN COURSE c ON e.CourseID = c.CourseID
WHERE e.StudentID = 3456 AND c.CourseName = 'Introduction to Psychology';