---- Hospital Reporting Basics

use hospital_managment;

-- select * from doctor where consultation_fee>700;

-- select department_id,count(doctor_id) as doctor_count from doctor group by department_id;

-- SELECT department_id, COUNT(doctor_id) AS doctor_count
-- FROM doctor
-- GROUP BY department_id
-- HAVING COUNT(doctor_id) > 3;

-- select department_id ,count(doctor_id) as doctor_count_de 
-- from doctor where consultation_fee>700 group by department_id
-- having count(doctor_id)>2;

-- select department_id ,avg(salary) from doctor where salary>50000 
-- group by department_id having avg(salary)>70000;

-- SELECT department_id,
--        SUM(salary) AS total_salary
-- FROM doctor
-- GROUP BY department_id
-- HAVING SUM(salary) > 200000;


-- block 2 project

-- SELECT
--     p.first_name AS patient_name,
--     d.first_name AS doctor_name,
--     dp.department_name,
--     a.appointment_datetime
-- FROM appointment a
-- JOIN patients p
--     ON a.patient_id = p.patient_id
-- JOIN doctor d
--     ON a.doctor_id = d.doctor_id
-- JOIN department dp
--     ON d.department_id = dp.department_id;

-- WITH dept_avg AS (
--     SELECT department_id, AVG(salary) AS avg_salary
--     FROM doctor
--     GROUP BY department_id
-- )
-- SELECT
--     d.first_name,
--     d.salary,
--     da.avg_salary
-- FROM doctor d
-- JOIN dept_avg da
--     ON d.department_id = da.department_id
-- WHERE d.salary > da.avg_salary;

-- select doctor_id ,first_name,consultation_fee from doctor where consultation_fee =(select 
-- max(consultation_fee) from doctor);



