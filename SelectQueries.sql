create database amit;
use amit;

create table product(pid int PRIMARY KEY, pname varchar(10)NOT NULL,price int NOT NULL,decription varchar(20));

insert into product values(1,"book",100,"agnipankh");
insert into product values(2, 'Pencil', 10.00, 'HB pencil');
insert into product values(3, 'Paper', 50.00, 'A4 size paper bundle');
insert into product values(5, 'Phone', 15000.00, 'Smartphone');


select * from product;

create table ordertables1(orderid int primary key,pid int ,quantity int,total int, city varchar(30),delivery_status varchar(50));

insert into ordertables1 values(106,1,5,100,"pune","delivered");
insert into ordertables1 values(107,2,10,300,"delhi","undelivered");
insert into ordertables1 values(108,3,8,400,"hyderabad","delivered");
insert into ordertables1 values(109,4,15,180,"mumbai","undelivered");
insert into ordertables1 values(110,5,20,190,"benglore","delivered");


          select * from ordertables1;
          select * from ordertables where total>200;
          select * from ordertables1 where total>200;
          select * from product where pname like "p%";
          select* from ordertables1 where delivery_status="undelivered";
          select * from ordertables1 where city = "pune" and delivery_status ="undelivered";
          select * from ordertables1 where orderid in (607,603,601);
          select * from ordertables1 where city in("pune","mumbai");
          select * from ordertables1 where total>800;
          select max(price) from product order by price desc limit 5; 
          update ordertables1 set delivery_status = "delivered" where orderid =109;