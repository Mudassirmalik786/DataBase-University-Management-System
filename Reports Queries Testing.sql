--Assessment wise Result of student
SELECT 
    st.StudentId,
    s.FirstName AS Name,
    s.RegistrationNumber AS RegNo,
    Assessment.Title AS Assessment,
    st.AssessmentComponentId AS ACID,
    ac.TotalMarks AS Marks,
    rl.MeasurementLevel,
    MAX(rl2.MeasurementLevel) AS MaxLevel,
    CAST((CAST(rl.MeasurementLevel AS FLOAT) / MAX(CAST(rl2.MeasurementLevel AS FLOAT))) * ac.TotalMarks AS FLOAT) AS OMarks
FROM StudentResult AS st
JOIN Student AS s ON st.StudentId = s.Id
JOIN AssessmentComponent AS ac ON ac.Id = st.AssessmentComponentId
JOIN Rubric AS r ON r.Id = ac.RubricId
JOIN RubricLevel AS rl ON rl.Id = st.RubricMeasurementId
JOIN RubricLevel AS rl2 ON rl2.RubricId = r.Id
JOIN Assessment ON Assessment.Id = ac.AssessmentId
GROUP BY st.StudentId, st.AssessmentComponentId, ac.TotalMarks, rl.MeasurementLevel, s.FirstName, s.RegistrationNumber, Assessment.Title;

--CLO Wise Result of Students who attemp assessments
SELECT S.RegistrationNumber,  
SUM(AC.TotalMarks)AS TotalMarks,
Cast(SUM(((RL.MeasurementLevel / (RL.Maximum * 1.0)) * AC.TotalMarks))as int) AS ObtainedMarks
FROM 
    Student S
JOIN StudentResult SR ON S.Id = SR.StudentId
JOIN AssessmentComponent AC ON AC.Id = SR.AssessmentComponentId
JOIN Assessment A ON A.Id = AC.AssessmentId
JOIN Rubric R ON R.Id = AC.RubricId
JOIN Clo C ON C.Id = R.CloId
JOIN RubricLevel RL ON SR.RubricMeasurementId = RL.Id
GROUP BY S.RegistrationNumber;


--CLO wise marks of students in each assessment 
SELECT 
    CONCAT(s.FirstName, s.LastName) AS StudentName,
    s.RegistrationNumber,
    Clo.Name AS CloName,
    Assessment.Title AS AssessmentTitle,
    ac.Name AS AComponent,
    ac.TotalMarks AS TotalMarks,
    CAST((rl.MeasurementLevel / rl2.MeasurementLevel) * ac.TotalMarks AS FLOAT) AS ObtainedMarks
FROM StudentResult st
JOIN Student s ON st.StudentId = s.Id
JOIN AssessmentComponent ac ON ac.Id = st.AssessmentComponentId
JOIN Rubric r ON r.Id = ac.RubricId
JOIN RubricLevel rl ON rl.Id = st.RubricMeasurementId
JOIN RubricLevel rl2 ON rl2.RubricId = r.Id
JOIN Assessment ON Assessment.Id = ac.AssessmentId
JOIN Clo ON r.CloId = Clo.Id
GROUP BY st.AssessmentComponentId, ac.TotalMarks, rl.MeasurementLevel, CONCAT(s.FirstName, s.LastName), s.RegistrationNumber, Clo.Name,
    ac.Name, Assessment.Title;

