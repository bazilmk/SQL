SELECT MAX(mark)
FROM enrolment
WHERE unitcode = 'FIT1004' AND semester = 1 AND to_char(ofyear, 'yyyy') = '2013';

SELECT AVG(mark)
FROM enrolment
WHERE unitcode = 'FIT1040' AND semester = '2' AND to_char(ofyear, 'yyyy') = '2013';

SELECT AVG(mark), semester, to_char(ofyear, 'yyyy')
FROM enrolment
WHERE unitcode = 'FIT1040'
GROUP BY semester, to_char(ofyear, 'yyyy')
ORDER BY to_char(ofyear, 'yyyy');

SELECT COUNT(s.studid)
FROM student s, enrolment e1
WHERE s.studid = e1.studid
AND to_char(ofyear, 'yyyy') = '2013'
AND unitcode = 'FIT1040';

SELECT COUNT(DISTINCT s.studid)
FROM student s, enrolment e1
WHERE s.studid = e1.studid
AND to_char(ofyear, 'yyyy') = '2013'
AND unitcode = 'FIT1040';

SELECT COUNT(studid), unitcode, semester, to_char(ofyear, 'yyyy')
FROM enrolment
WHERE to_char(ofyear, 'yyyy') = '2013'
GROUP BY unitcode, semester, to_char(ofyear, 'yyyy')
ORDER BY COUNT(studid);

SELECT COUNT(has_prereq_of)
FROM prereq
WHERE unitcode = 'FIT2077';

SELECT COUNT(has_prereq_of), unitcode
FROM prereq
GROUP BY unitcode;

SELECT COUNT(p1.unitcode), has_prereq_of, u.unitname
FROM prereq p1, unit u 
WHERE u.unitcode = p1.has_prereq_of
GROUP BY has_prereq_of, u.unitname;

SELECT unitcode
FROM enrolment
WHERE to_char(ofyear, 'yyyy') = '2013'
GROUP BY unitcode
HAVING COUNT(studid) = (SELECT MAX(COUNT(studid)) FROM enrolment
                        WHERE to_char(ofyear, 'yyyy') = '2013'
                        GROUP BY unitcode);
                        
SELECT studfname, studlname, studdob
FROM student
WHERE studdob = (SELECT MIN(studdob) FROM student);

SELECT studfname, studlname, mark, unitcode
FROM student s,enrolment e1
WHERE s.studid = e1.studid AND semester = 1 
AND to_char(e1.ofyear, 'yyyy') = '2013' AND unitcode = 'FIT1004'
AND mark > (SELECT AVG(mark) FROM enrolment
            WHERE semester = 1 AND to_char(ofyear, 'yyyy') = '2013' and unitcode = 'FIT1004')
ORDER BY mark DESC;


#WEEK 6 - Tutorial!

#1
SELECT u.unitcode, COUNT(p1.has_prereq_of) as no_of_prereq
FROM unit u, prereq p1
WHERE u.unitcode = p1.unitcode(+)                        
GROUP BY u.unitcode;

#2.0 using set operator
SELECT u.unitcode, u.unitname
FROM unit u
MINUS
SELECT u.unitcode, u.unitname
FROM unit u, prereq p1
WHERE u.unitcode = p1.has_prereq_of(+)
AND p1.has_prereq_of IS NOT NULL;

#3
SELECT unitcode, semester, to_char(ofyear, 'yyyy'), to_char(ROUND(NVL(AVG(mark), 0.00), 2), '80.00') AS average
FROM enrolment e1
GROUP BY unitcode, ofyear, semester
ORDER BY average;

#2.1 using outer join

SELECT u.unitcode, u.unitname
FROM unit u, prereq p1
WHERE u.unitcode = pr.unitcode (+)
AND pr.unitcode IS NULL;