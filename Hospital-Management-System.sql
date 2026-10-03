-- =====================================================================
-- Hospital Management System - SQL Project
-- Author: Sanjay Pujeri
-- Description: Relational database for managing hospital operations -
--              departments, doctors, patients, appointments, admissions,
--              and billing.
-- Dialect: MySQL (adjust AUTO_INCREMENT / DATE functions for other DBs)
-- =====================================================================

DROP DATABASE IF EXISTS hospital_management_system;
CREATE DATABASE hospital_management_system;
USE hospital_management_system;

-- ---------------------------------------------------------------------
-- 1. TABLES
-- ---------------------------------------------------------------------

CREATE TABLE departments (
    department_id   INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    floor_number    INT NOT NULL
);

CREATE TABLE doctors (
    doctor_id       INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    specialization  VARCHAR(50) NOT NULL,
    department_id   INT NOT NULL,
    phone           VARCHAR(15),
    hire_date       DATE NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE patients (
    patient_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    gender          ENUM('M', 'F', 'Other') NOT NULL,
    date_of_birth   DATE NOT NULL,
    phone           VARCHAR(15),
    address         VARCHAR(100),
    registered_on   DATE NOT NULL
);

CREATE TABLE appointments (
    appointment_id    INT AUTO_INCREMENT PRIMARY KEY,
    patient_id        INT NOT NULL,
    doctor_id         INT NOT NULL,
    appointment_date  DATE NOT NULL,
    appointment_time  TIME NOT NULL,
    status            ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    reason            VARCHAR(150),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE admissions (
    admission_id      INT AUTO_INCREMENT PRIMARY KEY,
    patient_id        INT NOT NULL,
    doctor_id         INT NOT NULL,
    room_number       VARCHAR(10) NOT NULL,
    admission_date    DATE NOT NULL,
    discharge_date    DATE,                      -- NULL while still admitted
    diagnosis         VARCHAR(150),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE billing (
    bill_id           INT AUTO_INCREMENT PRIMARY KEY,
    patient_id        INT NOT NULL,
    admission_id      INT,                       -- NULL for OPD-only bills
    bill_date         DATE NOT NULL,
    amount            DECIMAL(10, 2) NOT NULL,
    payment_status    ENUM('Paid', 'Pending', 'Partially Paid') DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);

-- ---------------------------------------------------------------------
-- 2. SAMPLE DATA
-- ---------------------------------------------------------------------

INSERT INTO departments (department_name, floor_number) VALUES
('Cardiology', 2),
('Orthopedics', 3),
('Pediatrics', 1),
('Neurology', 4),
('General Medicine', 1);

INSERT INTO doctors (first_name, last_name, specialization, department_id, phone, hire_date) VALUES
('Anil', 'Rao', 'Cardiologist', 1, '9900011122', '2019-03-15'),
('Priya', 'Nair', 'Orthopedic Surgeon', 2, '9900011123', '2020-06-01'),
('Suresh', 'Kumar', 'Pediatrician', 3, '9900011124', '2018-01-10'),
('Divya', 'Menon', 'Neurologist', 4, '9900011125', '2021-09-20'),
('Rahul', 'Shetty', 'General Physician', 5, '9900011126', '2022-02-14');

INSERT INTO patients (first_name, last_name, gender, date_of_birth, phone, address, registered_on) VALUES
('Ramesh', 'Gowda', 'M', '1985-04-12', '9811122233', 'Jayanagar, Bangalore', '2024-01-05'),
('Sneha', 'Hegde', 'F', '1992-11-23', '9811122234', 'Indiranagar, Bangalore', '2024-02-10'),
('Arjun', 'Patil', 'M', '2010-07-19', '9811122235', 'Whitefield, Bangalore', '2024-03-01'),
('Kavya', 'Reddy', 'F', '1978-02-28', '9811122236', 'HSR Layout, Bangalore', '2024-03-18'),
('Manoj', 'Desai', 'M', '1999-09-09', '9811122237', 'Koramangala, Bangalore', '2024-04-02'),
('Lakshmi', 'Iyer', 'F', '1965-12-01', '9811122238', 'Malleshwaram, Bangalore', '2024-05-21');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason) VALUES
(1, 1, '2026-01-10', '10:00:00', 'Completed', 'Chest pain follow-up'),
(2, 3, '2026-01-11', '11:30:00', 'Completed', 'Child routine checkup'),
(3, 3, '2026-01-12', '09:15:00', 'No-Show', 'Fever'),
(4, 2, '2026-01-14', '14:00:00', 'Completed', 'Knee pain'),
(5, 5, '2026-01-15', '16:00:00', 'Scheduled', 'General checkup'),
(6, 4, '2026-01-16', '12:00:00', 'Completed', 'Memory loss evaluation'),
(1, 1, '2026-02-10', '10:00:00', 'Scheduled', 'Cardiology follow-up');

INSERT INTO admissions (patient_id, doctor_id, room_number, admission_date, discharge_date, diagnosis) VALUES
(4, 2, 'OR-201', '2026-01-14', '2026-01-20', 'Knee replacement surgery'),
(6, 4, 'NR-401', '2026-01-16', NULL, 'Under observation - neurological evaluation'),
(1, 1, 'CR-105', '2026-02-10', '2026-02-12', 'Cardiac monitoring');

INSERT INTO billing (patient_id, admission_id, bill_date, amount, payment_status) VALUES
(4, 1, '2026-01-20', 185000.00, 'Paid'),
(6, 2, '2026-01-25', 45000.00, 'Partially Paid'),
(1, 3, '2026-02-12', 32000.00, 'Pending'),
(2, NULL, '2026-01-11', 800.00, 'Paid'),
(5, NULL, '2026-01-15', 600.00, 'Pending');

-- ---------------------------------------------------------------------
-- 3. USEFUL QUERIES
-- ---------------------------------------------------------------------

-- 3.1 List all doctors with their department name
SELECT d.first_name, d.last_name, d.specialization, dep.department_name
FROM doctors d
JOIN departments dep ON d.department_id = dep.department_id;

-- 3.2 Patients currently admitted (not yet discharged)
SELECT p.first_name, p.last_name, a.room_number, a.admission_date, a.diagnosis
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
WHERE a.discharge_date IS NULL;

-- 3.3 Number of appointments handled by each doctor
SELECT doc.first_name, doc.last_name, COUNT(ap.appointment_id) AS total_appointments
FROM doctors doc
LEFT JOIN appointments ap ON doc.doctor_id = ap.doctor_id
GROUP BY doc.doctor_id, doc.first_name, doc.last_name
ORDER BY total_appointments DESC;

-- 3.4 Total billed amount and total pending amount per patient
SELECT p.first_name, p.last_name,
       SUM(b.amount) AS total_billed,
       SUM(CASE WHEN b.payment_status IN ('Pending', 'Partially Paid') THEN b.amount ELSE 0 END) AS pending_amount
FROM patients p
JOIN billing b ON p.patient_id = b.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY pending_amount DESC;

-- 3.5 Average length of stay (in days) per department, for discharged patients
SELECT dep.department_name,
       ROUND(AVG(DATEDIFF(a.discharge_date, a.admission_date)), 1) AS avg_stay_days
FROM admissions a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
JOIN departments dep ON doc.department_id = dep.department_id
WHERE a.discharge_date IS NOT NULL
GROUP BY dep.department_name;

-- 3.6 Doctors who have never had a "No-Show" appointment (NOT EXISTS)
SELECT doc.first_name, doc.last_name
FROM doctors doc
WHERE NOT EXISTS (
    SELECT 1 FROM appointments ap
    WHERE ap.doctor_id = doc.doctor_id AND ap.status = 'No-Show'
);

-- 3.7 Rank patients by total amount billed (window function)
SELECT p.first_name, p.last_name, SUM(b.amount) AS total_billed,
       RANK() OVER (ORDER BY SUM(b.amount) DESC) AS billing_rank
FROM patients p
JOIN billing b ON p.patient_id = b.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;

-- 3.8 Monthly revenue trend from billing (common BI-style query)
SELECT DATE_FORMAT(bill_date, '%Y-%m') AS billing_month,
       SUM(amount) AS monthly_revenue
FROM billing
GROUP BY DATE_FORMAT(bill_date, '%Y-%m')
ORDER BY billing_month;

-- 3.9 A view: active admissions with doctor and department info
CREATE OR REPLACE VIEW active_admissions_view AS
SELECT a.admission_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,
       doc.first_name AS doctor_first_name, doc.last_name AS doctor_last_name,
       dep.department_name, a.room_number, a.admission_date, a.diagnosis
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors doc ON a.doctor_id = doc.doctor_id
JOIN departments dep ON doc.department_id = dep.department_id
WHERE a.discharge_date IS NULL;

SELECT * FROM active_admissions_view;

-- 3.10 Index to speed up frequent lookups by appointment date
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
