create table dept
(
 deptno integer,
 dname varchar(14),
 loc varchar(13),
 constraint PK_dept primary key (deptno)
);

create table emp
(
 empno integer,
 ename varchar(10),
 job varchar(9),
 mgr integer,
 hiredate date,
 sal integer,
 comm integer,
 deptno integer,
 constraint FK_deptno foreign key (deptno) references dept (deptno),
 constraint PK_emp primary key (empno)
);

insert into dept values (10, 'ACCOUNTING', 'NEW YORK');
insert into dept values (20, 'RESEARCH', 'DALLAS');
insert into dept values (30, 'SALES', 'CHICAGO');
insert into dept values (40, 'OPERATIONS', 'BOSTON');

insert into emp values(7369, 'SMITH', 'CLERK', 7902,to_date('17/12/1980', 'DD/MM/YYYY'), 800, NULL, 20);
insert into emp values(7499, 'ALLEN', 'SALESMAN', 7698,to_date('20/02/1981', 'DD/MM/YYYY'), 1600, 300, 30);
insert into emp values(7521, 'WARD', 'SALESMAN', 7698,to_date('22/02/1981', 'DD/MM/YYYY'), 1250, 500, 30);
insert into emp values(7566, 'JONES', 'MANAGER', 7839,to_date('2/04/1981', 'DD/MM/YYYY'), 2975, NULL, 20);
insert into emp values(7654, 'MARTIN', 'SALESMAN', 7698,to_date('28/09/1981', 'DD/MM/YYYY'), 1250, 1400, 30);
insert into emp values(7698, 'BLAKE', 'MANAGER', 7839,to_date('1/05/1981', 'DD/MM/YYYY'), 2850, NULL, 30);
insert into emp values(7782, 'CLARK', 'MANAGER', 7839,to_date('9/06/1981', 'DD/MM/YYYY'), 2450, NULL, 10);
insert into emp values(7788, 'SCOTT', 'ANALYST', 7566,to_date('09/12/1982', 'DD/MM/YYYY'), 3000, NULL, 20);
insert into emp values(7839, 'KING', 'PRESIDENT', null,to_date('17/11/1981', 'DD/MM/YYYY'), 5000, NULL, 10);
insert into emp values(7844, 'TURNER', 'SALESMAN', 7698,to_date('8/09/1981', 'DD/MM/YYYY'), 1500, 0, 30);
insert into emp values(7876, 'ADAMS', 'CLERK', 7788,to_date('12/01/1983', 'DD/MM/YYYY'), 1100, NULL, 20);
insert into emp values(7900, 'JAMES', 'CLERK', 7698,to_date('3/12/1981', 'DD/MM/YYYY'), 950, NULL, 30);
insert into emp values(7902, 'FORD', 'ANALYST', 7566,to_date('3/12/1981', 'DD/MM/YYYY'), 3000, NULL, 20);
insert into emp values(7934, 'MILLER', 'CLERK', 7782,to_date('23/01/1982', 'DD/MM/YYYY'), 1300, NULL, 10);
