rem examen2
rem usuario bex2
/* si no esta el puerto escuchando dar click en start database, vereficarlo con comando lsnrctl

HACERLO EN SQLPLUS COMAND LINE
create user bex2 identified by bex2
deafault tablespace users
temporary tablespace temp;
grant connect , resource to bex2
connect bex2/ex2
show user
*/
rem acondicionar interfaz
set serveroutput on
set linesize 85
set pagesize 50
rem eliminar tablas
/*
delete table empleado,
delete table salario,
delete table obligaciones;
*/
CREATE TABLE empleado
(
id number(3) PRIMARY KEY,
nombre VARCHAR2(30),
rfc VARCHAR2(10),
curp VARCHAR2(10),
descripcion CHAR(20),
clave_emmpleado VARCHAR2(10)
);
CREATE TABLE salario 
(
id number(3) PRIMARY KEY REFERENCES empleado(id)
ON DELETE CASCADE,
monto varchar2(100),
dias number,
formula char(30)
);
CREATE TABLE obligaciones
(
id number(3) PRIMARY KEY REFERENCES empleado(id)
ON DELETE CASCADE ,
texto char(60)
);

REM INSERTS.
REM insertar datos en la tabla empleado
insert into empleado 
	(id,nombre,rfc,curp,descripcion,clave_emmpleado)
values (100,'Ismael Perez Ortega','PEOI951008JG0','PEOI951008HJCRRS09','Ingeniero en Sistemas','2014PEO0A5E8D');
insert into empleado 
	(id,nombre,rfc,curp,descripcion,clave_emmpleado)
values
       (101,'Fernando Daniel Olvera Cerros','OECF960219FC1','OECF960219HDFLRR00','Lider de proyectos','2015OECPE4B5C');
insert into empleado 
	(id,nombre,rfc,curp,descripcion,clave_emmpleado)
values   
	   (102,'Carlos Juarez Diaz','JUDC9605112Z5','JUDC960511HJCRZR06','Agente de ventas','2016JUDAAE57');
insert into empleado 
	(id,nombre,rfc,curp,descripcion,clave_emmpleado)
values
	   (103,'Aram Ortiz Bravo','O1BA9602136B8','OIB9960213HJCRRR08','IT','2017OIB568AC');	   
insert into empleado 
	(id,nombre,rfc,curp,descripcion,clave_emmpleado)
values
	   (104,'Juan Daniel Palma Garcia','PAGJ900714M86','PAGJ900714HJCLRN05','Transportista','2005PAGJ00EEA');
insert into empleado 
	(id,nombre,rfc,curp,descripcion,clave_emmpleado)
values
	   (105,'Juan Daniel Palma Garcia','PAGJ900714M86','PAGJ900714HJCLRN05','Transportista','2005PAGJ00EEA');	
REM insertar datos en la tabla salario
insert into salario values('50,000.00',10,'(50000(0.3)+(8*0.1))-420)',100);
insert into salario values('$40,000.00',51,'(40000(0.1)+(8*0.51))-120)',101);
insert into salario values('$45,000',17,'((45000(0.5)+(8*0.17))-85)*1.2',102);
insert into salario values('$1,500.00',5,'((36000(0.2)+(8*0.05))-10)',103);
insert into salario values('$500.00',14,'((36000(0.2)+(8*0.05))-10)',105);
REM insertar datos en la tabla obligaciones
insert into obligaciones  (texto, id)
values('Esta es una descripcion para el trabajador ismael np',100);
insert into obligaciones (texto, id)
values ('Esta descripcion corresponde al trabajador',101);
insert into obligaciones (texto,id)
values ('El trabajador carlos mv tiene esta descripcion',102);
insert into obligaciones (texto,id)
values ('Estos dos ultimos trabajadores no tendran',103);
insert into obligaciones (texto,id)
values ('Estos dos ultimos trabajadores no tendran los',104);











/* ESTA PARTE SON PRUEBAS QUE HICE EN MI BASE DE DATOS*/
REM alterar las tablas salario y obligaciones, cada una tenga una PK y FK
alter table salario
modify (id number(3) PRIMARY KEY);

alter table salario
ADD (id_empl number(3) REFERENCES empleado(id)
ON DELETE CASCADE);

alter table obligaciones
modify (id number(3) PRIMARY KEY);
alter table obligaciones
ADD (id_empl number(3) REFERENCES empleado(id) 
ON DELETE CASCADE);
REM insertar datos en las tablas
alter table empleado
modify (rfc VARCHAR2(30));
alter table empleado
modify (curp VARCHAR2(30));
alter table empleado
modify (descripcion char(40));

alter table empleado 
modify (clave_emmpleado VARCHAR(15) );

REM insertar valores en tabla salario.
alter table salario
modify (formula char(30));
alter table salario
modify (dias number(3));
alter table salario
rename column id to id_sal;
alter table salario
rename column id_empl to id;

alter table salario
modify (CONSTRAINT salario  FOREIGN KEY (id) REFERENCES empleado(id)
ON DELETE CASCADE);
alter table salario
DROP column id_sal;
alter table salario 
DROP  column id;
alter table salario
add (id number(3) PRIMARY KEY REFERENCES empleado(id));
alter table obligaciones 
drop column id_empl;
alter table obligaciones
drop column id;
alter table obligaciones
add (id number(3) PRIMARY KEY REFERENCES empleado(id));
alter table obligaciones
modify (texto char(60));

insert into obligaciones  (texto, id)
values('Esta es una descripcion para el trabajador ismael np',100);
insert into obligaciones (texto, id)
values ('Esta descripcion corresponde al trabajador',101);
insert into obligaciones (texto,id)
values ('El trabajador carlos mv tiene esta descripcion',102);
insert into obligaciones (texto,id)
values ('Estos dos ultimos trabajadores no tendran',103);
insert into obligaciones (texto,id)
values ('Estos dos ultimos trabajadores no tendran los',104);






SELECT OWNER, TABLE_NAME, CONSTRAINT_NAME 
FROM all_constraints
WHERE EXISTS SELECT FROM all_constraints
WHERE TABLE_NAME=salario
AND OWNER=BEX2;




	   












