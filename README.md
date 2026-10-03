# Hospital Management System — SQL Project

A relational database design for managing core hospital operations: departments, doctors,
patients, appointments, admissions, and billing.

## Schema Overview

| Table | Purpose |
|---|---|
| `departments` | Hospital departments (Cardiology, Orthopedics, etc.) |
| `doctors` | Doctor details, linked to a department |
| `patients` | Patient registration details |
| `appointments` | OPD appointments between patients and doctors |
| `admissions` | In-patient admission and discharge records |
| `billing` | Charges linked to a patient, optionally to an admission |

**Relationships:**
- `doctors.department_id` → `departments.department_id`
- `appointments.patient_id` / `doctor_id` → `patients` / `doctors`
- `admissions.patient_id` / `doctor_id` → `patients` / `doctors`
- `billing.patient_id` → `patients`, `billing.admission_id` → `admissions` (nullable, for OPD-only bills)

## What's included

- Full `CREATE TABLE` schema with primary/foreign keys and constraints
- Sample data (6 patients, 5 doctors, 5 departments, appointments, admissions, bills)
- 10 queries covering:
  - Joins across multiple tables
  - Aggregates (`SUM`, `AVG`, `COUNT`) with `GROUP BY`
  - `NOT EXISTS` subquery
  - Window function (`RANK() OVER`)
  - Date functions (`DATEDIFF`, `DATE_FORMAT`) for stay duration and monthly revenue
  - A reusable `VIEW` for active admissions
  - An index for query performance

## How to run

```bash
mysql -u root -p < hospital_management_system.sql
```

(Written for MySQL; minor syntax changes needed for PostgreSQL/SQL Server — e.g.
`AUTO_INCREMENT` → `SERIAL`/`IDENTITY`, `DATEDIFF` → `date subtraction`.)

## Possible extensions

- Add a `prescriptions` table linked to appointments
- Add staff/nurse scheduling
- Add a stored procedure to auto-generate a bill on discharge
