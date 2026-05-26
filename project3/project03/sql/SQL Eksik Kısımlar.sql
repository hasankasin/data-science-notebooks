-- NVL fonksiyonu kullanarak null olana deðerlere istenilen deðerler atanabilir
select last_name, salary, NVL(commission_pct,0),
to_char((salary*12)+(salary*12*NVL(commission_pct,0)), 'l999,999.00') ANNUAL_SALARY
from hr.employees;

-- NVL2 fonksiyonu null deðer deðil ise bunu yaz null deðerse bunu yaz þeklinde kullanýlýr
select last_name, salary, commission_pct,
NVL2(commission_pct, 'FOUND','NOT FOUND') COMMISSION_SIT
from hr.employees;

-- CASE koþul ifadelerinde kullanýlýr
-- case = 'eðer bu'
-- when = 'böyle ise'
-- then = 'bunu yap'
select last_name,job_id,salary, 
        case job_id when 'IT_PROG' then 1.10*salary
                    when  'ST_CLERK' then 1.15*salary
                    when  'SA_REP' then 1.20*salary
        else salary end REVISED_SALARY
from hr.employees;

-- Kural koyarken en düþük kuralý ilk olarak yazmak gerekir
select last_name, salary, 
    case when salary < 5000 then 'low' 
          when salary < 10000 then 'medium' 
          when salary < 20000 then 'great' 
    else 'Excellent' end QUALIFIED_SALARY 
from hr.employees;

-- Decode case fonksiyonuna benzer mantýkta çalýþýr
select last_name,job_id,salary, 
    decode(job_id,  'IT_PROG', 1.10*salary, 
                    'ST_CLERK', 1.15*salary, 
                    'SA_REP', 1.20*salary, 
    salary) REVISED_SALARY 
from hr.employees;

-- Subqueries --

-- 106 numaralý çalýþandan daha fazla maaþ alanlarý getir
select * from hr.employees 
where employee_id = 106;
select first_name, salary from hr.employees 
where salary > 4800
order by salary;

-- Subquery mantýðý
select first_name, salary from hr.employees 
where salary > (select salary from hr.employees where employee_id = 106)
order by 2;

-- Davies'ten sonra iþe giren çalýþanlarý getir
select last_name, hire_date from hr.employees where last_name = 'Davies';
select last_name, hire_date from hr.employees 
where hire_date > (select hire_date from hr.employees where last_name = 'Davies');

-- Ernst'le ayný iþte çalýþýp maaþý Ernst'ten fazla olan çalýþanlarý getir
select last_name, job_id, salary from hr.employees 
where job_id = (select job_id from hr.employees where last_name = 'Ernst')
and salary > (select salary from hr.employees where last_name = 'Ernst');

-- Çalýþanlar arasýndan en düþük maaþ alaný getir
select last_name, job_id, salary from hr.employees
where salary = (select min(salary) from hr.employees);

-- 10. departmanda çalýþanlarýn arasýnda en düþük maaþý olandan fazla kazanan departmanlarýn en düþük maaþýný getir
select department_id, min(salary) from hr.employees group by department_id
having min(salary) > (select min(salary) from hr.employees where department_id = 10);

select last_name, job_id from hr.employees -- Kayýt dönmedi???
where job_id = (select job_id from hr.employees where last_name = 'Haas');

select employee_id, last_name from hr.employees -- HATA!!!
where salary = (select min(salary) from hr.employees group by department_id);

-- IT_PROG'daki çalýþanlarýn herhangi birinden daha düþük maaþ alanlarý getir
select employee_id, first_name, job_id, salary from hr.employees
where salary < any (select salary from hr.employees where job_id = 'IT_PROG');

-- IT_PROG'daki çalýþanlarýn hepsinden daha yüksek maaþ alanlarý getir
select employee_id, first_name, job_id, salary from hr.employees
where salary > all (select salary from hr.employees where job_id = 'IT_PROG');

-- Her bir departmandaki maaþý en düþük olan çalýþanlarý getir
select first_name, department_id, salary from hr.employees
where (salary, department_id) in (select min(salary), department_id from hr.employees group by department_id)
order by department_id;