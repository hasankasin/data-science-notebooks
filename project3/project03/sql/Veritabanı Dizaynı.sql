-- Join Türleri --
select * from hr.employees;

select * from hr.departments;

-- Hangi departmanda çalıştığını merak ediyorum
select e.employee_id, e.first_name, e.last_name, e.department_id, d.department_id, d.department_name
from hr.employees e
join hr.departments d on e.department_id = d.department_id;

select * from hr.locations;

select e.employee_id, l.city, d.department_name
from hr.employees e
join hr.departments d on d.department_id = e.department_id
join hr.locations l on d.location_id = l.location_id;

select e.employee_id, e.last_name, e.department_id, e.manager_id,
d.department_id, d.location_id
from hr.employees e join hr.departments d
on (e.department_id = d.department_id)
where e.manager_id = 149;

-- Ama benim 107 satırım vardı?
select e.employee_id, e.first_name, e.last_name, e.department_id, d.department_id, d.department_name
from hr.employees e
left join hr.departments d
on e.department_id = d.department_id; -- Departmanı belli olmayan kayıtları da getirdi!

--------------------------------------------- NOT ---------------------------------------------------
-- Left Join: Departmeni bilinmeyen çalışanları da getirir
-- Right Join: Hiç çalışanı olmayan departmanları da getirir
-- Full Join: Hem departmanı bilinmeyen çalışanları hem de hiç çalışanı olmayan departmanları getirir

-- Kartezyen çarpım
select e.last_name, d.department_name
from hr.employees e
cross join hr.departments d;

-- Tablo yapısını görme
describe hr.employees;

-- Veritabanı Oluşturma --
create table departments(
deptno number(2),
deptname varchar2(14),
loc varchar2(13),
create_date date default sysdate -- Sistemde kayıtlı tarih formatı
);

describe departments;

create table employees(
employee_id number(6)
constraint emp_emp_id_pk primary key, -- Constraint tanımlama (sütun bazında)
first_name varchar2(20)
);
describe employees;

create table employees2(
employee_id number(6),
first_name varchar2(20),
job_id varchar2(10) not null,
constraint emp_emp_id_pk2 -- Constraint tanımlama (tablo bazında)
primary key (employee_id)
);

create table employees3(
employee_id number(6) primary key,
first_name varchar2(20),
job_id varchar2(10) not null
);

describe employees3;

create table employees4(
employee_id number(6),
last_name varchar2(25) not null,
email varchar2(25),
constraint emp_email_uk unique(email), -- Email sütunu unique(benzersiz) değerler alsın
constraint mail_check check (email like '%@%')
);

describe employees4;

insert into employees4
values (23, 'Özarslan', 'ata.ozarslan@istdsa.com');

select * from employees4;

create table employees5(
employee_id number(6)
constraint emp_emp_id_pk primary key, 
first_name varchar2(20),
salary number(2)
constraint emp_salary_min
check (salary > 0) -- Bakiye sütunundaki değerler 0'dan büyük olsun
);

describe employees5;

create table employees6(
employee_id number(6),
last_name varchar2(25) not null,
email varchar2(25),
salary number(8),
commission_pct number(2),
hire_date date not null,
department_id number(4),
constraint emp_dept_fk foreign key (department_id)
references departments(deptno)
);

create table departments2(
deptno number(2) primary key, -- Foreign key'in tanımlanması için başka bir tablodaki primary key'e ihtiyaç vardır!
deptname varchar2(14),
loc varchar2(13),
create_date date default sysdate
);

describe departments2;
describe employees6;

alter table departments2
add (job_id varchar2(9)); -- Sütun ekleme

describe departments2;

alter table departments2
modify (job_id varchar2(25)); -- Sütun düzenleme

describe departments2;

alter table departments2
drop (job_id); -- Sütun silme

describe departments2;

alter table departments2 read only; -- Read Only modu
alter table departments2
drop (loc);

alter table departments2 read write; -- Read Write modu
alter table departments2
drop (loc);

drop table departments2; -- Tabloyu silme

describe departments2;

create table departments3(
department_id number(5) primary key,
department_name varchar2(14),
manager_id number(5),
location_id number(5)
);

describe departments3;

insert into departments3(department_id, department_name, manager_id, location_id) -- Tabloya yeni kayıt ekleme
values (70, 'Education', 100, 1700);

select * from departments3;

insert into departments3(department_id, department_name)
values (30, 'Purchasing');

select * from departments3;

insert into departments3
values (100, 'Finance', null, null);

select * from departments3;

insert into departments3(department_id, department_name, manager_id, location_id) -- HATA!!!
values (90, 200, 'IT', 1700);

insert into departments3(department_id, department_name, manager_id, location_id)
values (60, 200, 200, 1700);

select * from departments3; -- Niye hata vermedi???

insert into departments3 -- HATA!!!
values (50, 'Public Relations', 100, 1700);

alter table departments3
modify (department_name varchar2(25));

select * from departments3;

insert into departments3 -- HATA!!!
values (70, 'Education', 100, 1700);

insert into departments3
values (80, 'Public Relations', 120, 1800);

select * from departments3;

update departments3 -- HATA!!!
set department_id = 80
where department_name = 'Public Relations';

delete from departments3
where department_id = 80;

select * from departments3;

update departments3 -- Tabloda istenilen kayıtları düzenleme
set department_id = 80
where department_name = 'Public Relations';

select * from departments3;

truncate table departments3; -- Tablodaki tüm kayıtları silme

create table new_table as -- Bir tablodan istenilen kayıtları başka bir tabloya taşıma
select first_name, last_name, email from hr.employees;

describe new_table;
describe hr.employees;