-- WITH ranked_doctors AS (
--     SELECT
--         doctor_id,
--         first_name,
--         department_id,
--         salary,
--         DENSE_RANK() OVER (
--             PARTITION BY department_id
--             ORDER BY salary DESC
--         ) AS salary_rank
--     FROM doctor
-- )
-- SELECT
--     doctor_id,
--     first_name,
--     department_id,
--     salary,
--     salary_rank
-- FROM ranked_doctors
-- WHERE salary_rank <= 2;


use hospital_managment;

-- WITH payment_history AS (
--     SELECT
--         bill_id,
--         payment_id,
--         amount,
--         LAG(amount) OVER (
--             PARTITION BY bill_id
--             ORDER BY payment_id
--         ) AS previous_amount
--     FROM payment
-- )
-- SELECT
--     bill_id,
--     amount,
--     previous_amount,
--     amount - previous_amount AS difference
-- FROM payment_history;


-- WITH latest_appointment AS (
--     SELECT
--         appointment_id,
--         patient_id,
--         doctor_id,
--         appointment_datetime,
--         ROW_NUMBER() OVER (
--             PARTITION BY patient_id
--             ORDER BY appointment_datetime DESC
--         ) AS rn
--     FROM appointment
-- )
-- SELECT *
-- FROM latest_appointment
-- WHERE rn = 1;

SELECT
    doctor_id,
    appointment_datetime,
    LAG(appointment_datetime) OVER (
        PARTITION BY doctor_id
        ORDER BY appointment_datetime
    ) AS previous_appointment
FROM appointment;
