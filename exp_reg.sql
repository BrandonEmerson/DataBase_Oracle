--EXPRESIONES REGULARES 
--EJERCICIO1
REM empleados que cumplen en el mes de octubre
select nombre from empleado
where REGEXP_LIKE(curp,'([A-Z])+([0-9])+10([0-9])+([A-Z])+([0-9])+$');
select nombre from empleado
where REGEXP_LIKE(curp,'....951008.*');
--EJERCICIO2
REM CONSTRUCCION DE RFC CORRECTA
Alter table empleado
modify (rfc VARCHAR2(30) CONSTRAINT ck_emp_rfc CHECK (REGEXP_LIKE(rfc,'([A-Z]){4,5}([0-9]){2}((0[1-9])|(1[0-2]))((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))([A-Z 0-9]){3}$')));
INSERT INTO empleado(id,rfc) --no valido
values (200,'a  "+');
INSERT INTO empleado(id,rfc) -- valido
values (201,'VECJ880326XX0');
delete from empleado
where  rfc ='VECJ880326XX0' ;
select rfc from empleado
where  REGEXP_LIKE(rfc,'([A-Z]){4,5}([0-9]){2}((0[1-9])|(1[0-2]))((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))([A-Z 0-9]){3}$');
select rfc from empleado
where not REGEXP_LIKE(rfc,'([A-Z]){4,5}([0-9]){2}((0[1-9])|(1[0-2]))((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))([A-Z 0-9]){3}$');
--EJERCICIO 3
REM CONSTRUCCION DE curp CORRECTA
ALTER TABLE empleado
modify (curp VARCHAR(30) CONSTRAINT ck_emp_curp CHECK (REGEXP_LIKE(curp,'^([A-Z])+([0-9])+((0[1-9])|(1[0-2]))([0-9])+([A-Z])+([0-9])+$')));
INSERT INTO empleado(id,curp)--no valido
values(202,'a  13  -');
INSERT INTO empleado (id,curp)
values(203,'SEEB960831HDFRSR03');--valido
DELETE FROM empleado
where id= 203;
select curp from empleado
where REGEXP_LIKE(curp,'^([A-Z])+([0-9])+((0[1-9])|(1[0-2]))([0-9])+([A-Z])+([0-9])+$');
select curp from empleado
where not  REGEXP_LIKE(curp,'^([A-Z])+([0-9])+((0[1-9])|(1[0-2]))([0-9])+([A-Z])+([0-9])+$');
--EJERCICIO 4
ALTER TABLE empleado
modify (clave_emmpleado VARCHAR(15) CONSTRAINT ck_emp_clave_emmpleado CHECK (REGEXP_LIKE(clave_emmpleado,'^([0-9]){4}([A-Z]){3}([:xdigit:]){5}$')));
ALTER TABLE empleado
ADD CONSTRAINT ck_emp_clv CHECK (REGEXP_LIKE(clave_emmpleado,'^([0-9]){4}([A-Z]){3}([:xdigit:]){5}$'));
SELECT id FROM empleado
where REGEXP_LIKE(id,'^([0-9]){4}([A-Z]){3}([:xdigit:]){5}$');
select id from empleado
where not REGEXP_LIKE(id,'^([0-9]){4}([A-Z]){3}([:xdigit:]){5}$');
0-9A-Fa-f

{3}(0-9 A-F a-f)


