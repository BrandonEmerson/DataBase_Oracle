--LAB 13.1
--before triggers
CREATE OR REPLACE TRIGGER student_bi 
BEFORE INSERT ON student 
FOR EACH ROW 
DECLARE v_student_id STUDENT.STUDENT_ID%TYPE; 
BEGIN SELECT STUDENT_ID_SEQ.NEXTVAL 
INTO v_student_id FROM dual; 
:NEW.student_id    := v_student_id; 
:NEW.created_by    := USER; 
:NEW.created_date  := SYSDATE; 
:NEW.modified_by   := USER; 
:NEW.modified_date := SYSDATE;
end;
INSERT INTO student (first_name, last_name, zip, registration_date) VALUES ('John', 'Smith', '00914', SYSDATE);
--After triggers
CREATE OR REPLACE TRIGGER instructor_aud 
AFTER UPDATE OR DELETE ON INSTRUCTOR 
DECLARE v_type VARCHAR2(10); 
BEGIN 
IF UPDATING THEN 
v_type := 'UPDATE'; 
ELSIF DELETING THEN 
v_type := 'DELETE'; 
END IF; 
	UPDATE statistics 
	SET transaction_user = USER, 
	transaction_date = SYSDATE 
	WHERE table_name = 'INSTRUCTOR' AND transaction_name = v_type; 
IF SQL%NOTFOUND 
THEN INSERT INTO statistics VALUES ('INSTRUCTOR', v_type, USER, SYSDATE); 
END IF; 
END;
---autonomous transaction
CREATE OR REPLACE TRIGGER instructor_aud 
AFTER UPDATE OR DELETE ON INSTRUCTOR 
DECLARE v_type VARCHAR2(10); 
PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN 
IF UPDATING 
THEN v_type := 'UPDATE'; 
ELSIF DELETING THEN v_type := 'DELETE'; 
END IF; 
UPDATE statistics SET transaction_user = USER, 
transaction_date = SYSDATE 
WHERE table_name  = 'INSTRUCTOR' AND transaction_name = v_type; 
IF SQL%NOTFOUND THEN INSERT INTO statistics VALUES ('INSTRUCTOR', v_type, USER, SYSDATE);
 END IF; COMMIT; 
 END; 
 --13.1.1
 CREATE TRIGGER student_au 
 AFTER UPDATE ON STUDENT 
 FOR EACH ROW WHEN (NVL(NEW.ZIP, ' ') <> OLD.ZIP);
 UPDATE instructor 
 SET phone = '7181234567' WHERE instructor_id = 101;
 --a) con replace, remplazo un trigger ya existente
 --b) for each row, dispara el trigger por cada renglon de la tabla
 --13.1.2 Use before and after triggers
 CREATE OR REPLACE TRIGGER instructor_bi 
 BEFORE INSERT ON INSTRUCTOR 
 FOR EACH ROW 
 DECLARE v_work_zip CHAR(1); 
 BEGIN 
 :NEW.CREATED_BY := USER; 
 :NEW.CREATED_DATE := SYSDATE; 
 :NEW.MODIFIED_BY   := USER; 
 :NEW.MODIFIED_DATE := SYSDATE; 
 SELECT 'Y' INTO v_work_zip FROM zipcode 
 WHERE zip = :NEW.ZIP; 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR (-20001, 'Zip code is not valid!'); 
 END; 
 --13.1.2 Version A
CREATE OR REPLACE TRIGGER instructor_bi 
BEFORE INSERT ON INSTRUCTOR 
FOR EACH ROW 
DECLARE v_work_zip CHAR(1);
 BEGIN 
	:NEW.CREATED_BY := USER; 
	:NEW.CREATED_DATE := SYSDATE;
	:NEW.MODIFIED_BY := USER; 
	:NEW.MODIFIED_DATE := SYSDATE; 
		IF :NEW.ZIP IS NULL 
		THEN RAISE_APPLICATION_ERROR (-20002, 'Zip code is missing!'); 
		ELSE SELECT 'Y' INTO v_work_zip FROM zipcode 
		WHERE zip = :NEW.ZIP; 
	 END IF; 
EXCEPTION 
	WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR (-20001, 'Zip code is not valid!'); 
	END;
--
-- For Example ch13_8c.sql
CREATE OR REPLACE TRIGGER instructor_bi
BEFORE INSERT ON INSTRUCTOR
FOR EACH ROW
DECLARE
   v_work_zip CHAR(1);
BEGIN
   :NEW.CREATED_BY    := USER;
   :NEW.CREATED_DATE  := SYSDATE;
   :NEW.MODIFIED_BY   := USER;
   :NEW.MODIFIED_DATE := SYSDATE;
   
   SELECT 'Y'
     INTO v_work_zip
     FROM zipcode
    WHERE zip = :NEW.ZIP;

   :NEW.INSTRUCTOR_ID := INSTRUCTOR_ID_SEQ.NEXTVAL;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
       RAISE_APPLICATION_ERROR (-20001, 'Zip code is not valid!');
END;

-- For Example ch13_9a.sql
CREATE TABLE course_cost_log
   (course_no NUMBER
   ,cost      NUMBER
   ,modified_by VARCHAR2(30)
   ,modified_date DATE)
/

CREATE OR REPLACE TRIGGER course_au
AFTER UPDATE ON COURSE
FOR EACH ROW
WHEN (NEW.COST <> OLD.COST)
BEGIN
   INSERT INTO course_cost_log
      (course_no, cost, modified_by, modified_date)
   VALUES
      (:old.course_no, :old.cost, USER, SYSDATE);
END;
/

-- For Example ch13_9b.sql
CREATE OR REPLACE TRIGGER course_au
AFTER UPDATE ON COURSE
FOR EACH ROW
WHEN (NVL(NEW.COST, -1) <> NVL(OLD.COST, -1))
BEGIN
   INSERT INTO course_cost_log
      (course_no, cost, modified_by, modified_date)
   VALUES
      (:old.course_no, :old.cost, USER, SYSDATE);
END;

-- For Example ch13_10a.sql
CREATE OR REPLACE TRIGGER course_bi
BEFORE INSERT ON COURSE
FOR EACH ROW
BEGIN
   :NEW.COURSE_NO     := COURSE_NO_SEQ.NEXTVAL;
   :NEW.CREATED_BY    := USER;
   :NEW.CREATED_DATE  := SYSDATE;
   :NEW.MODIFIED_BY   := USER;
   :NEW.MODIFIED_DATE := SYSDATE;
END;

-- For Example ch13_10b.sql
CREATE OR REPLACE TRIGGER course_bi
BEFORE INSERT ON COURSE
FOR EACH ROW
DECLARE
   v_prerequisite COURSE.COURSE_NO%TYPE;
BEGIN
   IF :NEW.PREREQUISITE IS NOT NULL 
   THEN
      SELECT course_no
        INTO v_prerequisite
        FROM course
       WHERE course_no = :NEW.PREREQUISITE;
   END IF;

   :NEW.COURSE_NO     := COURSE_NO_SEQ.NEXTVAL;
   :NEW.CREATED_BY    := USER;
   :NEW.CREATED_DATE  := SYSDATE;
   :NEW.MODIFIED_BY   := USER;
   :NEW.MODIFIED_DATE := SYSDATE;
EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
       RAISE_APPLICATION_ERROR (-20002, 'Prerequisite is not valid!');
END;

-- For Example ch13_11a.sql
CREATE VIEW student_address 
    AS 
       SELECT s.student_id, s.first_name, s.last_name, s.street_address, z.city, z.state
             ,z.zip
         FROM student s
         JOIN zipcode z
           ON (s.zip = z.zip);
/

CREATE OR REPLACE TRIGGER student_address_ins
INSTEAD OF INSERT ON student_address 
FOR EACH ROW
BEGIN 
   INSERT INTO STUDENT 
      (student_id, first_name, last_name, street_address, zip, registration_date
      ,created_by, created_date, modified_by, modified_date)
   VALUES
      (:NEW.student_id, :NEW.first_name, :NEW.last_name, :NEW.street_address, :NEW.zip
      ,SYSDATE, USER, SYSDATE, USER, SYSDATE);
END;
/ 

-- For Example ch13_11b.sql
CREATE OR REPLACE TRIGGER student_address_ins
INSTEAD OF INSERT ON student_address 
FOR EACH ROW
DECLARE
   v_zip VARCHAR2(5);
BEGIN
   SELECT zip
     INTO v_zip
     FROM zipcode
    WHERE zip = :NEW.ZIP;

   INSERT INTO STUDENT 
      (student_id, first_name, last_name, street_address, zip, registration_date
      ,created_by, created_date, modified_by, modified_date)
   VALUES
      (:NEW.student_id, :NEW.first_name, :NEW.last_name, :NEW.street_address
      ,:NEW.zip, SYSDATE, USER, SYSDATE, USER, SYSDATE);

EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RAISE_APPLICATION_ERROR (-20002, 'Zip code is not valid!');
END;

-- For Example ch13_11c.sql
CREATE OR REPLACE TRIGGER student_address_ins
INSTEAD OF INSERT ON student_address 
FOR EACH ROW
DECLARE
   v_zip VARCHAR2(5);
BEGIN
   BEGIN
      SELECT zip
        INTO v_zip
        FROM zipcode
       WHERE zip = :NEW.zip;
   EXCEPTION
      WHEN NO_DATA_FOUND 
      THEN
         INSERT INTO ZIPCODE
            (zip, city, state, created_by, created_date, modified_by, modified_date)
         VALUES
            (:NEW.zip, :NEW.city, :NEW.state, USER, SYSDATE, USER, SYSDATE);
   END;
   INSERT INTO STUDENT 
      (student_id, first_name, last_name, street_address, zip, registration_date
      ,created_by, created_date, modified_by, modified_date)
   VALUES
      (:NEW.student_id, :NEW.first_name, :NEW.last_name, :NEW.street_address
      ,:NEW.zip, SYSDATE, USER, SYSDATE, USER, SYSDATE);
END;

-- For Example ch13_12a.sql
CREATE OR REPLACE TRIGGER enrollment_bi
BEFORE INSERT ON ENROLLMENT
FOR EACH ROW
DECLARE
   v_valid NUMBER := 0;
BEGIN
   SELECT COUNT(*)
     INTO v_valid
     FROM student
    WHERE student_id = :NEW.STUDENT_ID;
   
   IF v_valid = 0 
   THEN
      RAISE_APPLICATION_ERROR (-20000, 'This is not a valid student');
   END IF;
   
   SELECT COUNT(*)
     INTO v_valid
     FROM section
    WHERE section_id = :NEW.SECTION_ID;
   
   IF v_valid = 0 
   THEN 
      RAISE_APPLICATION_ERROR (-20001, 'This is not a valid section');
   END IF;

   :NEW.ENROLL_DATE   := SYSDATE;
   :NEW.CREATED_BY    := USER;
   :NEW.CREATED_DATE  := SYSDATE;
   :NEW.MODIFIED_BY   := USER;
   :NEW.MODIFIED_DATE := SYSDATE;
END;

-- For Example ch13_13a.sql
CREATE OR REPLACE TRIGGER section_bu
BEFORE UPDATE ON SECTION
FOR EACH ROW
DECLARE
   v_valid NUMBER := 0;
BEGIN
   IF :NEW.INSTRUCTOR_ID IS NOT NULL 
   THEN
      SELECT COUNT(*)
        INTO v_valid
        FROM instructor
       WHERE instructor_id = :NEW.instructor_ID;
      
      IF v_valid = 0 
      THEN
         RAISE_APPLICATION_ERROR (-20000, 'This is not a valid instructor');
      END IF;
   END IF;
   
   :NEW.MODIFIED_BY   := USER;
   :NEW.MODIFIED_DATE := SYSDATE;
END;

-- 