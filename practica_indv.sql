--1. Hacer un procedimiento que muestre el nombre y el salario del empleado cuyo código es 7782

create or replace procedure ejer1
is
    v_nombre emp.ename%type;
    v_salario emp.sal%type;
begin
    select ename, sal into v_nombre, v_salario from emp where empno = '7782';
    dbms_output.put_line('Nombre: '||v_nombre||' Salario: '||v_salario);
end;
/

--2. Hacer un procedimiento que reciba como parámetro un código de empleado y devuelva su nombre

create or replace procedure ejer2 (p_codemp emp.empno%type)
is
    v_nombre emp.ename%type;
begin 
    select ename into v_nombre from emp where empno = p_codemp;
    dbms_output.put_line('Nombre: '||v_nombre);
end;
/

--3. Hacer un procedimiento que devuelva los nombres de los tres empleados más antiguos

create or replace procedure ejer3
is
    cursor c_cursor is 
    select ename from emp where rownum <= '3' order by hiredate desc;
begin
    for var in c_cursor loop
        dbms_output.put_line('Nombre: '||var.ename);
    end loop;
end;
/

--4. Hacer un procedimiento que reciba el nombre de un tablespace y muestre los nombres de los usuarios que lo tienen como tablespace por defecto (Vista DBA_USERS)

create or replace procedure ejer4(p_tablespace dba_tablespaces.tablespace_name%type)
is
    cursor c_cursor is 
    select username from dba_users where default_tablespace = p_tablespace;
begin 
    for var in c_cursor loop
        dbms_output.put_line('Usr: '||var.username);
    end loop;
end;
/

--5. Modificar el procedimiento anterior para que haga lo mismo pero devolviendo el número de usuarios que tienen ese tablespace como tablespace por defecto. Nota: Hay que convertir el procedimiento en función

--Listar Usuarios--
create or replace function f_listar_user_tablespace(p_tablespacename varchar2)
return varchar2
is
    v_username dba_users.username%type;
    cursor c_cursor is 
    select username from dba_users where default_tablespace = p_tablespacename;
begin 
    for var in c_cursor loop
        v_username := var.username;
        dbms_output.put_line('Usuario: '||v_username); 
    end loop;
    return v_username;
end;
/

--Contar Usuarios--
create or replace function f_contar_user_tablespace(p_tablespacename varchar2)
return number
is 
    v_count number := 0;
    cursor c_cursor is 
    select username from dba_users where default_tablespace = p_tablespacename;
begin
    for var in c_cursor loop 
        v_count := v_count + 1;
    end loop;
    return v_count;
end;
/

--Funcion Final--
create or replace function f_ejer5(p_tablespacename varchar2)
return varchar2
is
    v_listar dba_users.username%type;
    v_final number;
begin 
    v_listar := f_listar_user_tablespace(p_tablespacename);
    v_final := f_contar_user_tablespace(p_tablespacename);
    dbms_output.put_line('Total usuarios tablespace '||p_tablespacename||': '||v_final);
    return v_listar;
end;
/

--6. Hacer un procedimiento llamado mostrar_usuarios_por_tablespace que muestre por pantalla un listado de los tablespaces existentes con la lista de usuarios de cada uno y el número de los mismos, así: (Vistas DBA_TABLESPACES y DBA_USERS)

--Listar Total de Usuarios BD--
create or replace procedure UserBd
is 
    v_total number;
begin 
    select count(username) into v_total from dba_users;
    dbms_output.put_line('Total Usuarios BD: '||v_total);
end;
/

--Procedimiento Final--
create or replace procedure MostrarUserTablespace
is 
    cursor c_cursor is
    select tablespace_name from dba_tablespaces;
begin 
    for var in c_cursor loop
        dbms_output.put_line('Tablespace '||var.tablespace_name||':');
        ejer4(var.tablespace_name);
        ejer5(var.tablespace_name);
        dbms_output.put_line('---------------------------');
    end loop;
    UserBd;
end;
/

--7. Hacer un procedimiento llamado mostrar_codigo_fuente  que reciba el nombre de otro procedimiento y muestre su código fuente. (DBA_SOURCE)

create or replace procedure MostrarCodFuente
is
    cursor c_cursor is
    select text from dba_source where name = 'EJER4'; 
begin 
    for var in c_cursor loop
        dbms_output.put_line(var.text);
    end loop;
end;
/

--8. Hacer un procedimiento llamado mostrar_privilegios_usuario que reciba el nombre de un usuario y muestre sus privilegios de sistema y sus privilegios sobre objetos. (DBA_SYS_PRIVS y DBA_TAB_PRIVS)

--Listar Privilegios del sistema--
create or replace procedure PrivSys(p_username dba_sys_privs.grantee%type)
is 
    cursor c_cursor is 
    select privilege from dba_sys_privs where grantee = p_username group by privilege;
begin 
    for var in c_cursor loop 
        dbms_output.put_line('Privilegios del sistema: '||var.privilege);
    end loop;
end;
/

--Listar Privilegios de los objetos--
create or replace procedure PrivTab(p_username dba_tab_privs.grantee%type)
is 
    cursor c_cursor is 
    select privilege from dba_tab_privs where grantee = p_username group by privilege;
begin 
    for var in c_cursor loop 
        dbms_output.put_line('Privilegios de objetos: '||var.privilege);
    end loop;
end;
/

--Procedimiento Final--
create or replace procedure MostrarPrivUser(p_username dba_tab_privs.grantee%type)
is 
begin 
    PrivSys(p_username);
    PrivTab(p_username);
end;
/

--9. Realiza un procedimiento llamado listar_comisiones que nos muestre por pantalla un listado de las comisiones de los empleados agrupados según la localidad donde está ubicado su departamento con el siguiente formato:

--Excepcion Comprbar Tabla Vacia--
create or replace procedure ComprobarTablaVacia
is
    v_vacia number;
begin
    select count(*) into v_vacia from dept, emp;
    
    if v_vacia = 0 then
        raise_application_error(-20000,'Tabla vacia');
    end if;
end;
/

--Excepcion Comprobar que la comision no sea mayor que 10000--
create or replace procedure ComisionMayor
is
    v_comision number;
begin
    select count(*) into v_comision from emp where comm > 10000;
    if v_comision > 0 then
        raise_application_error(-20001,'Hay alguna comision mayor de 10000');
    end if;
end;
/

--Listar Empleados y Comisiones--
create or replace procedure EmpleadoComisiones(p_loc dept.loc%type)
is 
    cursor c_cursor is 
    select ename, comm from emp where deptno in (select deptno from dept where dname = p_loc) order by ename asc;
begin 
    for var in c_cursor loop  
        dbms_output.put_line(chr(9)||chr(9)||'Empleado: '||var.ename||chr(9)||chr(9)||'Comision: '||var.comm);
    end loop;
end;
/

--Listar Total Comisiones del Departamento--
create or replace procedure TotalCommDept(p_dname dept.dname%type)
is
    v_total number := 0;
begin
    select sum(comm) into v_total from emp where deptno in (select deptno from dept where dname = p_dname);
    if v_total is null then
        dbms_output.put_line('Total Comisiones en el Departamento '||p_dname||':');
    else
        dbms_output.put_line('Total Comisiones en el Departamento '||p_dname||': '||v_total);
    end if;
end;
/

--Listar Despartamentos--
create or replace procedure Departamento(p_loc dept.loc%type)
is
    cursor c_cursor is 
    select dname from dept where loc = p_loc;
begin
    for var in c_cursor loop 
        dbms_output.put_line(chr(9)||'Departamento: '||var.dname);
        EmpleadoComisiones(var.dname);
        TotalCommDept(var.dname);
    end loop;
end;
/

--Listar Total Comisiones en la Localidad--
create or replace procedure TotalCommLoc(p_loc dept.loc%type)
is 
    v_total number := 0;
begin 
    select sum(comm) into v_total from emp where deptno in (select deptno from dept where loc = p_loc);
    if v_total is null then
        dbms_output.put_line('Total Comisiones en la Localidad '||p_loc||':');
    else
        dbms_output.put_line('Total Comisiones en la Localidad '||p_loc||': '||v_total);
    end if;
end;
/

--Listar Total Comisiones en la Empresa--
create or replace procedure TotalCommEmp
is 
    v_total number;
begin 
    select count(comm) into v_total from emp;
    dbms_output.put_line('Total Comisiones en la Empresa: '||v_total);
end;
/

--Procedimiento Final--
create or replace procedure ListarComisiones
is 
    cursor c_cursor is 
    select loc from dept group by loc order by loc asc;
begin
    ComprobarTablaVacia;
    ComisionMayor;
    for var in c_cursor loop
        dbms_output.put_line('Localidad: '||var.loc);
        Departamento(var.loc);
        TotalCommLoc(var.loc);
    end loop;
    TotalCommEmp;
end;
/

--10. Realiza un procedimiento que reciba el nombre de una tabla y muestre los nombres de las restricciones que tiene, a qué columna afectan y en qué consisten exactamente. (DBA_TABLES, DBA_CONSTRAINTS, DBA_CONS_COLUMNS)

create or replace procedure ListarRestricc(p_table varchar2)
is 
    cursor c_cursor is 
    select a.constraint_name, b.column_name, a.constraint_type from dba_constraints a, dba_cons_columns b, dba_tables c where a.constraint_name = b.constraint_name and a.table_name = c.table_name and a.table_name = p_table group by a.constraint_name, b.column_name, a.constraint_type; 
begin
    for var in c_cursor loop
        dbms_output.put_line('Tabla: '||p_table);
        dbms_output.put_line('Restriccion: '||var.constraint_name);
        dbms_output.put_line('Columna: '||var.column_name);
        dbms_output.put_line('Consiste: '||var.constraint_type);
        dbms_output.put_line('------------------------------');
    end loop;
end;
/

--11. Realiza al menos dos de los ejercicios anteriores en Postgres usando PL/pgSQL.

--Ejercicio 1--
CREATE OR REPLACE PROCEDURE EJER1()
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_nombre VARCHAR;
    v_salario VARCHAR;
BEGIN 
    select ename, sal into v_nombre, v_salario
    from emp
    where empno = '7782';

    RAISE NOTICE 'Nombre (%)', v_nombre;
    RAISE NOTICE 'Salario (%)', v_salario;
END
$$;

--Ejercicio 2--
CREATE OR REPLACE PROCEDURE DEVOLVERNOMBRE(p_codemp INTEGER)
LANGUAGE 'plpgsql'
AS $$
DECLARE
    v_nombre VARCHAR;
BEGIN 
    select ename into v_nombre 
    from emp 
    where empno = p_codemp;

    RAISE NOTICE 'Nombre (%)', v_nombre;
END
$$;