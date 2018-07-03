--ver que usuario tiene el schema student
DESC ALL_TABLES;
SELECT TABLE_NAME, OWNER
FROM ALL_TABLES
WHERE TABLE_NAME LIKE '%STUDENT%';--usuario 23 tiene el schema student
REM CREAR OTRO USUARIO PARA EL EXAMEN 2 CON ESQUEMA STUDENT
CREATE USER EX2 IDENTIFIED BY X2
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE TO EX2;
CONNECT EX2/X2;
--CARGAR ESQUEMA(BASE DE DATOS) DE STUDENT PARA PODER HACE RLO EJERCICIOS
 @C:\Users\USER20\Desktop\createStudent.SQL
 --aparecen errores, cambiar el nls_parameter e english
 set page size 99
 column parameter format A30
 column value format a30
 select parameter, value from nls_session_parameters;
 alter session set nls_date_language = 'english'
 --perfect!
 --MAKE USE OF THE RECORD USE 11.1.1
 set serveroutput on;
 DECLARE 
 registro1 zipcode%ROWTYPE;
 BEGIN
 SELECT * INTO registro1
 FROM zipcode
 WHERE ROWNUM<2;
 DBMS_OUTPUT.put_line(registro1.ZIP);
 DBMS_OUTPUT.put_line(registro1.CITY);
 DBMS_OUTPUT.put_line(registro1.STATE);
 DBMS_OUTPUT.put_line(registro1.CREATED_BY);
 DBMS_OUTPUT.put_line(registro1.CREATED_DATE);
 DBMS_OUTPUT.put_line(registro1.MODIFIED_BY);
 DBMS_OUTPUT.put_line(registro1.MODIFIED_DATE);
 END;
 --processing an explicit cursor 11.1.2
 set serveroutput on;
 DECLARE
 CURSOR c_student IS 
 SELECT FIRST_NAME, LAST_NAME  
 FROM STUDENT;
 registro2 c_student%ROWTYPE;
 BEGIN
 OPEN c_student;
 FETCH c_student into registro2;
 DBMS_OUTPUT.put_line(registro2.FIRST_NAME);
 DBMS_OUTPUT.put_line(registro2.LAST_NAME);
 END;
 --solo aparece un renglon, por lo que tengo que hacer un loop
set serveroutput on;
DECLARE
CURSOR c_student IS 
SELECT FIRST_NAME, LAST_NAME,PHONE
FROM STUDENT;
registro2 c_student%ROWTYPE;
BEGIN
OPEN c_student;
LOOP 
FETCH c_student into registro2;
DBMS_OUTPUT.put_line(registro2.FIRST_NAME);
DBMS_OUTPUT.put_line(registro2.LAST_NAME);
EXIT WHEN c_student%NOTFOUND;
 END LOOP;
 END;
set serveroutput on;
DECLARE
Cursor c_zipcode IS
SELECT * FROM zipcode;
registro3 c_zipcode%ROWTYPE;
BEGIN
OPEN c_zipcode;
LOOP
FETCH c_zipcode into registro3;
DBMS_OUTPUT.PUT_LINE('ZIOCODE:'||registro3.ZIP ||''||registro3.CITY||''||registro3.modified_by);
EXIT WHEN c_zipcode%NOTFOUND;
END LOOP;
CLOSE c_zipcode;
END;

DBMS_OUTPUT.PUT_LINE(registro3.ZIP);
DBMS_OUTPUT.PUT_LINE(registro3.CITY);
DBMS_OUTPUT.PUT_LINE(registro3.STATE);
DBMS_OUTPUT.PUT_LINE(registro3.CREATED_BY);
DBMS_OUTPUT.PUT_LINE(registro3.CREATED_DATE);
DBMS_OUTPUT.PUT_LINE(registro3.CREATED_BY);
DBMS_OUTPUT.PUT_LINE(registro3.MODIFIED_DATE);

--
SET SERVEROUTPUT ON; 
DECLARE CURSOR c_student_name IS SELECT first_name, last_name FROM student
WHERE ROWNUM<5;
registro4 c_student_name%ROWTYPE;
BEGIN
OPEN c_student_name;
LOOP
FETCH c_student_name INTO registro4;
DBMS_OUTPUT.PUT_LINE('STUDENT NAME:' || registro4.FIRST_NAME||' ' || registro4.LAST_NAME);
EXIT WHEN c_student_name%NOTFOUND;
END LOOP;
CLOSE c_student_name;
END;
--MAKE USE OF CURSOR ATTRIBUTES 11.1.3
--cerrar el ciclo con un atributo de cursor y lanzar excepcion para cerrar el cursor 
SET SERVEROUTPUT ON; 
DECLARE CURSOR c_student_name IS SELECT first_name, last_name FROM student
WHERE ROWNUM<5;
registro4 c_student_name%ROWTYPE;
BEGIN
OPEN c_student_name;
LOOP
FETCH c_student_name INTO registro4;
DBMS_OUTPUT.PUT_LINE('STUDENT NAME:' || registro4.FIRST_NAME||' ' || registro4.LAST_NAME);
EXIT WHEN c_student_name%NOTFOUND;
END LOOP;
EXCEPTION
	WHEN OTHERS
	THEN
	IF c_student_name%ISOPEN
	THEN
	Close c_student_name;
	END IF;
END;
---atributo sql%rowcount, el numero de renglones afectados
SET SERVEROUTPUT ON;
DECLARE v_city zipcode.city%type;
BEGIN SELECT city INTO v_city FROM zipcode WHERE zip = 07002;
IF SQL%ROWCOUNT = 1 
	THEN DBMS_OUTPUT.PUT_LINE(v_city ||' has a '|| 'zipcode of 07002');
		ELSIF SQL%ROWCOUNT = 0
		THEN DBMS_OUTPUT.PUT_LINE('The zipcode 07002 is '|| ' not in the database'); 
		ELSE DBMS_OUTPUT.PUT_LINE('Stop harassing me'); 
		END IF;
		END;
--put it all togethuer 11.1.4
--describes example
DECLARE    
v_sid  student.student_id%TYPE;
CURSOR c_student IS
SELECT student_id  FROM student 
WHERE student_id < 110;
BEGIN
OPEN c_student; 
LOOP 
FETCH c_student INTO v_sid;
EXIT WHEN c_student%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('STUDENT ID : '||v_sid);
END LOOP;
CLOSE c_student;
EXCEPTION
WHEN OTHERS
	THEN
	IF c_student%ISOPEN
	THEN
	Close c_student;
	END IF;
END;
--ADD attributes %found and %rowcount
DECLARE    
v_sid  student.student_id%TYPE;
CURSOR c_student IS
SELECT student_id  FROM student 
WHERE student_id < 110;
BEGIN
OPEN c_student; 
LOOP 
	FETCH c_student INTO v_sid;
	IF c_student%FOUND
	THEN 
		DBMS_OUTPUT.PUT_LINE('Just fetch :'||to_char(c_student%ROWCOUNT)||''||
		'STUDENT ID : '||v_sid);
		ELSE 
		EXIT;
	END IF;
		END LOOP;
CLOSE c_student;
EXCEPTION
WHEN OTHERS
	THEN
	IF c_student%ISOPEN
	THEN
	Close c_student;
	END IF;
END;
--inciso c 
Declare
CURSOR c_student IS
select FIRST_NAME, LAST_NAME, STUDENT_ID
FROM student
WHERE student_id<110;
registro1 c_student%ROWTYPE;
BEGIN
OPEN c_student;
LOOP
	FETCH c_student into registro1;
	DBMS_OUTPUT.PUT_LINE(registro1.first_name ||' '||registro1.last_name||' ' ||registro1.student_id);
    EXIT WHEN c_student%NOTFOUND;
END LOOP;
CLOSE c_student;
EXCEPTION
	WHEN OTHERS
	THEN
	IF c_student%ISOPEN
	then
	CLOSE c_student;
	END IF;
END;
--inciso c BIEN
DECLARE
Cursor c_student_enrollment IS
SELECT s.student_id,first_name,last_name,
	COUNT(*) enroll,
	(CASE 
	WHEN COUNT(*) = 1 THEN 'class'
	WHEN COUNT(*) IS NULL THEN 'NO Classes'
	ELSE 'CLASSES'
	END )class
FROM STUDENT s, ENROLLMENT e
WHERE s.student_id = e.student_id 
and s.student_id < 110
GROUP BY s.student_id, first_name, last_name;
registro1 c_student_enrollment%ROWTYPE;
BEGIN
OPEN c_student_enrollment;
LOOP
FETCH c_student_enrollment into registro1;	
		DBMS_OUTPUT.put_line(registro1.student_id||' ' || registro1.first_name||' ' || registro1.last_name|| ' ' ||registro1.enroll||registro1.class);
	EXIT WHEN c_student_enrollment%NOTFOUND;
END LOOP;
CLOSE c_student_enrollment;
EXCEPTION
	WHEN OTHERS
	THEN
	IF c_student_enrollment%ISOPEN
	THEN 
	CLOSE c_student_enrollment;
	END IF;
END;
--USING CURSOR FOR LOOPS AND NESTED LOOPS
--example
create table table_log
(description VARCHAR2(250));

DECLARE
CURSOR c_student is
SELECT student_id, last_name, first_name
FROM student
where student_id<110;
BEGIN
FOR r_student IN c_student
LOOP 
INSERT into table_log
VALUES(r_student.last_name); 
END LOOP; 
END;
select * from table_log;
--11.2.1 USE A CURSOR FOOR LOOP
DECLARE
CURSOR c_group_discount IS
SELECT  DISTINCT course_no
FROM section s  , enrollment e
WHERE s.section_id = e.section_id
GROUP BY  s.course_no, e.section_id, s.section_id
HAVING COUNT(*)>=8;
BEGIN
FOR r_group_discount IN c_group_discount LOOP
UPDATE course
set cost = cost *.95 
where course_no = r_group_discount.course_no;
END LOOP;
COMMIT;
END;
select cost from course;
--11.2.2 NESTED FOR LOOP
--example
set serveroutput on;
DECLARE 
v_zip zipcode.zip%TYPE;
v_student_flag CHAR;        
CURSOR c_zip IS 
SELECT zip, city, state FROM zipcode
WHERE state = 'CT'; 
CURSOR c_student IS 
SELECT first_name, last_name FROM student 
WHERE zip = v_zip; 
BEGIN FOR r_zip IN c_zip LOOP 
v_student_flag := 'N'; 
v_zip := r_zip.zip;
DBMS_OUTPUT.PUT_LINE(CHR(10)); 
DBMS_OUTPUT.PUT_LINE('Students living in '||r_zip.city); 
	FOR r_student in c_student LOOP DBMS_OUTPUT.PUT_LINE(r_student.first_name||' '||r_student.last_name);
	v_student_flag := 'Y';           
	END LOOP;
IF v_student_flag = 'N' THEN DBMS_OUTPUT.PUT_LINE ('No Students for this zipcode'); 
END IF; 
END LOOP; 
END;
--excercise a)
set serveroutput on; 
Declare 
aux student.student_id%TYPE;
Cursor c_father is 
SELECT student_id, first_name, last_name from student
where student_id < 110;
Cursor c_son is
SELECT c.course_no, c.description
FROM course c, section s, enrollment e
where 
c.course_no = s.course_no
AND s.section_id= e.section_id
AND e.student_id = aux ;
BEGIN 
FOR index1 IN c_father LOOP
aux := index1.student_id;
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE(index1.student_id||''||index1.first_name||''||index1.last_name);
	FOR index2 IN c_son LOOP
	DBMS_OUTPUT.PUT_LINE('is enrolled in : '||index2.course_no);
	end loop;
END LOOP;
END;
--excercise b)
SET SERVEROUTPUT ON 
DECLARE 
v_amount course.cost%TYPE; 
v_instructor_id  instructor.instructor_id%TYPE;
CURSOR c_inst IS 
SELECT first_name, last_name, instructor_id FROM instructor;
CURSOR c_cost IS SELECT c.cost FROM course c, section s, enrollment e 
WHERE s.instructor_id = v_instructor_id 
AND c.course_no = s.course_no 
AND s.section_id = e.section_id;
BEGIN FOR r_inst IN c_inst LOOP 
v_instructor_id := r_inst.instructor_id; 
v_amount := 0; 
DBMS_OUTPUT.PUT_LINE( 'Amount generated by instructor '|| r_inst.first_name||' '||r_inst.last_name ||' is');
	FOR r_cost IN c_cost LOOP v_amount := v_amount + NVL(r_cost.cost, 0); 
	END LOOP; 
DBMS_OUTPUT.PUT_LINE ('     '||TO_CHAR(v_amount,'$999,999')); END LOOP;
 END;
--try it yourself CHINGON
set serveroutput on;
Declare
aux1 section.section_id%type;
cursor padre is
SELECT s.section_id, s.section_no,c.course_no,c.description
FROM section s, course c
where  s.course_no=c.course_no;
cursor hijo is 
select count(*) enroll
from enrollment e
where e.section_id = aux1;
BEGIN 
FOR index1 in padre LOOP
aux1 := index1.section_id;
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('CURSO:'||index1.description||''||'seccion:'||index1.section_no);
	for index2 in hijo LOOP
	DBMS_OUTPUT.PUT_LINE('INSCRITOS:'||index2.enroll);
	end loop;	
end loop;
end;
--try it yourself chafaldrana
set serveroutput on; 
Declare 
aux1 section.section_id%type;
aux_course course.course_no%type;
cursor primero is 
Select course_no, description
From course
WHERE course_no <120;
cursor segundo is 
Select s.section_id, e.section_id, count(*) enroll
from   section s, enrollment e
where s.section_id = e.section_id
GROUP BY s.section_no;
BEGIN 
for index1 in primero LOOP
aux_course := index1.course_no;
DBMS_OUTPUT.PUT_LINE('CURSO: '||aux_course||''||index1.description);
end loop;
end;
--try it yourself 2 
SET SERVEROUTPUT ON;
DECLARE 
v_instid_min     instructor.instructor_id%TYPE; 
v_section_id_new section.section_id%TYPE;
v_snumber_recent section.section_no%TYPE := 0;
--Este cursor determina los cursos que estan llenos
CURSOR c_filled IS 
SELECT DISTINCT s.course_no 
FROM section s 
WHERE s.capacity = 
(SELECT COUNT(section_id) 
FROM enrollment e 
WHERE e.section_id = s.section_id);
BEGIN
FOR r_filled in c_filled LOOP
--PARA ESTE CURSOR, AQUELLOS CURSOS QUE  NO TENGAN UN NUMERO MAXIMO DE INSCRITOS, AGREGAR UN CAMPO DE INSTRUCTOR 
SELECT instructor_id INTO v_instid_min 
FROM instructor WHERE EXISTS 
(SELECT NULL FROM section WHERE section.instructor_id = instructor.instructor_id 
GROUP BY instructor_id HAVING COUNT(*) = 
(SELECT MIN(COUNT(*)) FROM section WHERE instructor_id IS NOT NULL GROUP BY instructor_id) ) AND ROWNUM = 1;
dbms_output.put_line(r_filled.course_no);
dbms_output.put_line(v_instid_min);
end loop;
--DETERMINA EL ID DE LA SECCION PARA LA NUEVA SECCION
SELECT MAX(section_id) + 1 INTO v_section_id_new FROM section;
DECLARE CURSOR c_snumber_in_parent IS SELECT section_no FROM section
WHERE course_no = r_filled.course_no ORDER BY section_no; 
BEGIN
FOR r_snumber_in_parent IN c_snumber_in_parent LOOP 
EXIT WHEN r_snumber_in_parent.section_no > v_snumber_recent + 1; 
v_snumber_recent := r_snumber_in_parent.section_no + 1; 
END LOOP;
END;
end;










	
	


	






 

 
 
 


