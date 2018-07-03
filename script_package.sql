set serverout on
set feedback on
create or replace package examen_2 as
	function FECHA(param in varchar2) return varchar2;
	procedure RFC;
	procedure CURP;
	procedure CLAVE;
	procedure SALARIO;
	procedure OBLIGACIONES;
	procedure MONTO;
	procedure NOMBRE;
end examen_2; 
/

create or replace package body examen_2 as
	function FECHA(param in varchar2) return varchar2
	is 
		prueba varchar2(30);
	begin
		select nombre 
		into prueba
		from empleado
		where regexp_like(curp,'....'||param||'*');
	return prueba;
	end FECHA;
	
	procedure RFC
	is 
		c number;
	begin
		select count(*)
		into c
		from empleado
		where not regexp_like(rfc,'[A-Z]{4}[0-9]{6}...');
		
		if (c = 0) then
			dbms_output.put_line('Todos los RFC Son correctos');
		else 
			dbms_output.put_line('Hay '|| c ||' RFC incorrecto(s)');
		end if;
	end RFC;
	
	procedure CURP
	is 
		c number;
	begin
		select count(*)
		into c
		from empleado
		where not regexp_like(curp,'[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}');
		if (c = 0) then
			dbms_output.put_line('Todos los RFC Son correctos');
		else 
			dbms_output.put_line('Hay '|| c ||' CURP incorrecto(s)');
		end if;
	end CURP;
	
	procedure CLAVE
	is
		c number;
	begin
		select count(*)
		into c
		from empleado
		where not regexp_like(clave_emmpleado,'[0-9]{4}[A-Z]{3}([A-E]|[0-9]){5}');--emmpleado
		if (c = 0) then
			dbms_output.put_line('Todas las CLAVES son correctas');
		else 
			dbms_output.put_line('Hay '|| c ||' CLAVES incorrecta(s)');
		end if;
	end CLAVE;
	
	procedure SALARIO
	is
		c number;
	begin
		select count(*)
		into c
		from empleado a
		inner join salario b 
		on  a.id=b.id
		where regexp_like(dias,'^[0-9]$|^1[0-5]$');
		if (c = 0) then
			dbms_output.put_line('La cantidad de dias para todos los trabajadores es menor a 15');
		else 
			dbms_output.put_line('Hay '|| c ||' trabajadores que tienen mas de 15 dias');
		end if;
	end SALARIO;
	
	procedure OBLIGACIONES
	is
		c number;
	begin
		select count(*)
		into c
		from obligaciones
		where regexp_like(texto,'.*(mv|np|nb).*');
		if (c = 0) then
			dbms_output.put_line('En el texto de los trabajores no se encontraron las paralabras mv,nb,np');
		else 
			dbms_output.put_line('Hay '|| c ||' textos con las palabras mv,nb,np');
		end if;
	end OBLIGACIONES;
	
	procedure MONTO
	is
		c number;
	begin
		select count(*)
		into c
		from salario
		where not regexp_like(monto,'^\(?\$[0-9]*,?[0-9]{3}\.[0-9]{2}');
		if (c = 0) then
			dbms_output.put_line('Todos los salarios están en el formato correcto');
		else 
			dbms_output.put_line('Hay '|| c ||' salarios cuyo formato no es correcto');
		end if;
	end MONTO;
	
	procedure NOMBRE
	is
		c number;
	begin
		select count(*)
		into c
		from empleado
		where regexp_like(nombre,'.*[ ].*[ ].*[ ].*([ ].*)*');
		if (c = 0) then
			dbms_output.put_line('No hay ningún nombre empleado con dos nombres o apellido compuesto');
		else 
			dbms_output.put_line('Hay '|| c ||' empleado(s) con dos nombres o apellido compuesto');
		end if;
	end NOMBRE;
end examen_2;
/


set feedback off;

--column "Nombre" format A30;
--select examen_2.FECHA('960511') as "Nombre" from dual;
--select examen_2.FECHA('951008') as "Nombre" from dual;

exec examen_2.RFC;
exec examen_2.CURP;
exec examen_2.CLAVE;
exec examen_2.SALARIO;
exec examen_2.OBLIGACIONES;
exec examen_2.MONTO;
exec examen_2.NOMBRE;