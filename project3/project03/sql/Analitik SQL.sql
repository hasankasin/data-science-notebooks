-- Analitik SQL --

-- Her bir departmandaki toplam maaþlar ne kadar
select department_id, sum(salary) from hr.employees
group by department_id order by department_id;

-- Þirkette ödenen toplam maaþýn kiþilere göre daðýlýmýný getir
select first_name, salary, sum(salary) over (order by first_name) as emp_salary
from hr.employees;

-- Her bir departmanda çalýþanlar o departmanda alýnan toplam maaþýn ne kadarýný alýyor
select first_name, department_id, salary, sum(salary) over (partition by department_id order by salary) as dept_salary
from hr.employees order by department_id;

-- Departman bazýnda maaþlarý en baþtan sona kadar toplar
select employee_id, first_name, department_id, salary, sum(salary) over (partition by department_id order by employee_id rows between unbounded preceding and current row) as cumulative
from hr.employees order by employee_id;

-- Bir önceki ile bir sonraki maaþ deðerlerinin ortalamasýný alýr
select employee_id, first_name, department_id, salary, avg(salary) over (partition by department_id order by employee_id rows between 1 preceding and 1 following) as cumulative
from hr.employees order by employee_id;

-- Departman bazýnda maksimum maaþ deðerini diðer deðerlere atar
select first_name, department_id, salary, first_value(salary) over (partition by department_id order by salary desc) as dept_max_salary
from hr.employees order by department_id;

-- Bir önceki kiþinin maaþýný getir
select employee_id, first_name, salary, lag(salary, 1) over (order by salary) as last_salary, salary - lag(salary, 1) over (order by salary) as salary_diff
from hr.employees;

-- Bir sonraki kiþinin maaþýný verir
select employee_id, first_name, salary, lead(salary, 1) over (order by salary) as next_salary
from hr.employees;

-- Ayný departmanda çalýþanlarý yan yana getirir
select department_id, listagg(first_name, ',') within group (order by department_id) as dept_employees
from hr.employees group by department_id;

-- Maaþa göre büyükten küçüðe sýra numarasý verir
select department_id, last_name, salary, rank() over (partition by department_id order by salary desc) as sal_rank
from hr.employees where department_id = 60 order by department_id, sal_rank, salary;

-- Maaþý ayný olan çalýþanlar varsa onlarý ayný sýra numarasýnda verir
select department_id, last_name, salary, rank() over (partition by department_id order by salary desc) as sal_rank, 
dense_rank() over (partition by department_id order by salary desc) as sal_dense_rank
from hr.employees where department_id = 60 order by sal_rank;

-- Çalýþanlarýn maaþ sýralamalarýnýn yüzde kaça denk geldiðini verir
select department_id, last_name, salary, percent_rank() over (partition by department_id order by salary) as percentage
from hr.employees where department_id = 60 order by department_id, percentage;