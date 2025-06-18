create database academy;
use academy;
create table employees2(eid int, ename varchar(10),salary int,depertment_id int,location_id int, hire_date date);
insert into employees2 values(1,"alice",25000,1,1,"2022-01-15");
insert into employees2 values(2,"bob",22000,1,2,"2022-02-20");
insert into employees2 values(3,"charlie",28000,2,1,"2022-03-10");
insert into employees2 values(4,"david",20000,2,2,"2022-04-05");
insert into employees2 values(5,"eve",30000,1,1,"2022-01-07");
select * from employees2;

create table department(did int,dname varchar(20));
insert into department values(1,"marketing");
insert into department values(2,"developement");
insert into department values(3,"suppurt");
select * from department;

create table location(lid int, city varchar(30));
insert into location values(1,"pune");
insert into location values(2,"mumbai");
select * from location;

SELECT e.eid, e.ename, e.salary, d.did,d.dname
FROM employees2 e
JOIN department d ON e.depertment_id = d.did 
WHERE d.dname = 'marketing';

select e.ename ,e.salary, d.dname
from employees2 e
join department d on e.depertment_id = d.did 
where salary>=(select avg(salary)from employees2);

select e.ename ,e.salary, d.dname
from employees2 e
join department d on e.depertment_id = d.did 
where d.dname="marketing"
and e.salary=(select min(salary)from employees2 e2
join department d2 on e2.depertment_id=d2.did 
where d2.dname="marketing") ;

SELECT SUM(salary) FROM employees2;


select avg (e.salary)
from employees2 e
join department d on e.depertment_id = d.did
where d.dname="developement";

select sum(e.salary)
from employees2 e
join department d on e.depertment_id = d.did
where d.dname in("developement", "support");