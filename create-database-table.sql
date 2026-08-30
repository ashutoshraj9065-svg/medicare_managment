create database Hospital_managment;
use hospital_managment;

-- patient table create-- 
create table patients(patient_id int primary key auto_increment,first_name varchar(100)
not null, last_name varchar(100) not null, gender enum('male','female','other'), date_of_birth date not null, phone_number varchar(15)
unique not null , email varchar(100) unique not null, create_at datetime default current_timestamp);


-- department table

CREATE TABLE department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
); 


CREATE TABLE doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    salary DECIMAL(10,2) NOT NULL,
    consultation_fee DECIMAL(10,2) NOT NULL,
    department_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (department_id)
    REFERENCES department(department_id)
);


CREATE TABLE room (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type VARCHAR(20) NOT NULL,
    floor_number INT NOT NULL,
    daily_charge DECIMAL(10,2) NOT NULL,
    status ENUM('AVAILABLE','OCCUPIED','MAINTENANCE')
           DEFAULT 'AVAILABLE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- insert room 

INSERT INTO room
(room_number, room_type, floor_number, daily_charge)
VALUES
('A-101', 'GENERAL', 1, 1500.00);




CREATE TABLE bed (
    bed_id INT PRIMARY KEY AUTO_INCREMENT,
    bed_number VARCHAR(20) NOT NULL UNIQUE,
    room_id INT NOT NULL,
    status ENUM('AVAILABLE','OCCUPIED','MAINTENANCE')
           DEFAULT 'AVAILABLE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (room_id)
    REFERENCES room(room_id)
);

CREATE TABLE appointment (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    status ENUM('PENDING','APPROVED','REJECTED','COMPLETED','CANCELLED')
           DEFAULT 'PENDING',
    reason VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id),

    FOREIGN KEY (doctor_id)
    REFERENCES doctor(doctor_id)
);

-- insert appointment

INSERT INTO appointment
(patient_id, doctor_id, appointment_datetime, reason)
VALUES
(9999, 1, '2026-08-28 10:00:00', 'General Checkup');

CREATE TABLE admission (
    admission_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    admit_datetime DATETIME NOT NULL,
    discharge_datetime DATETIME NULL,
    status ENUM('ADMITTED','DISCHARGED','TRANSFERRED')
           DEFAULT 'ADMITTED',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
);

CREATE TABLE bed_assignment (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    admission_id INT NOT NULL,
    bed_id INT NOT NULL,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME NULL,

    FOREIGN KEY (admission_id)
    REFERENCES admission(admission_id),

    FOREIGN KEY (bed_id)
    REFERENCES bed(bed_id)
);

CREATE TABLE admission_doctor (
    admission_doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    admission_id INT NOT NULL,
    doctor_id INT NOT NULL,
    role VARCHAR(50) NOT NULL,
    assigned_from DATETIME NOT NULL,
    assigned_to DATETIME NULL,

    FOREIGN KEY (admission_id)
        REFERENCES admission(admission_id),

    FOREIGN KEY (doctor_id)
        REFERENCES doctor(doctor_id)
); 

CREATE TABLE treatment (
    treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT NULL,
    admission_id INT NULL,
    doctor_id INT NOT NULL,
    treatment_type VARCHAR(100) NOT NULL,
    treatment_datetime DATETIME NOT NULL,
    notes VARCHAR(100),

    FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id),

    FOREIGN KEY (admission_id)
        REFERENCES admission(admission_id),

    FOREIGN KEY (doctor_id)
        REFERENCES doctor(doctor_id),

    CHECK (
        (appointment_id IS NOT NULL AND admission_id IS NULL)
        OR
        (appointment_id IS NULL AND admission_id IS NOT NULL)
    )
);



CREATE TABLE prescription (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT NULL,
    admission_id INT NULL,
    doctor_id INT NOT NULL,
    prescription_date DATETIME NOT NULL,
    notes VARCHAR(200),

    FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id),

    FOREIGN KEY (admission_id)
        REFERENCES admission(admission_id),

    FOREIGN KEY (doctor_id)
        REFERENCES doctor(doctor_id),

    CONSTRAINT chk_prescription_context
    CHECK (
        (appointment_id IS NOT NULL AND admission_id IS NULL)
        OR
        (appointment_id IS NULL AND admission_id IS NOT NULL)
    )
);


CREATE TABLE medicine (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_name VARCHAR(100) NOT NULL UNIQUE,
    current_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prescription_medicine (
    prescription_medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dose VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50),

    FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescription_id),

    FOREIGN KEY (medicine_id)
        REFERENCES medicine(medicine_id)
);


CREATE TABLE bill (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    appointment_id INT NULL,
    admission_id INT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('UNPAID','PARTIAL','PAID') DEFAULT 'UNPAID',
    bill_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id),

    FOREIGN KEY (admission_id)
        REFERENCES admission(admission_id),

    CONSTRAINT chk_bill_context
    CHECK (
        (appointment_id IS NOT NULL AND admission_id IS NULL)
        OR
        (appointment_id IS NULL AND admission_id IS NOT NULL)
    )
);

CREATE TABLE bill_item (
    bill_item_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT NOT NULL,
    item_type VARCHAR(100) NOT NULL,
    description VARCHAR(100),
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (bill_id)
        REFERENCES bill(bill_id)
);

CREATE TABLE payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_mode ENUM('CASH','UPI','CARD','BANK_TRANSFER') NOT NULL,
    transaction_reference VARCHAR(100),

    FOREIGN KEY (bill_id)
        REFERENCES bill(bill_id)
);

INSERT INTO patients
(first_name, last_name, date_of_birth, gender, phone_number, email)
VALUES
('Ashu', 'Raj', '2000-05-10', 'Male', '9876543211', 'ashu@example.com');


INSERT INTO department
(department_name, location)
VALUES
('Cardiology', 'First Floor');


INSERT INTO doctor
(first_name, last_name, specialization, phone, email, salary, consultation_fee, department_id)
VALUES
('Ravi', 'Kumar', 'Cardiologist', '9876500001', 'ravi@hospital.com', 80000.00, 700.00, 1);


INSERT INTO room
(room_number, room_type, floor_number, daily_charge)
VALUES
('A-103', 'GENERAL', 1, 1500.00);


INSERT INTO bed
(bed_number, room_id)
VALUES
('B1', 1);


INSERT INTO appointment
(patient_id, doctor_id, appointment_datetime, reason)
VALUES
(1, 1, '2026-08-28 10:00:00', 'Chest pain');

select * from patients;

INSERT INTO appointment
(patient_id, doctor_id, appointment_datetime, reason)
VALUES
(1, 1, '2026-08-28 10:00:00', 'Chest pain');

select * from doctor;

INSERT INTO doctor
(first_name, last_name, specialization, phone, email, salary, consultation_fee, department_id)
VALUES
('Ravi', 'Kumar', 'Cardiologist', '9876500001', 'ravi@hospital.com', 80000.00, 700.00, 1);






