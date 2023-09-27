---- Database Objects 

DROP TABLE IF EXISTS jobs;
CREATE TABLE jobs(
    id INTEGER,
    job VARCHAR(500),
    update_date TIMESTAMP,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS departments;
CREATE TABLE departments(
    id integer,
    department VARCHAR(500),
    update_date TIMESTAMP,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS hired_employees;
CREATE TABLE hired_employees(
    id INTEGER,
    name VARCHAR(500),
    datetime TIMESTAMP,
    department_id INTEGER,
    job_id INTEGER,
    update_date TIMESTAMP,
    PRIMARY KEY(id),
    FOREIGN key(department_id) REFERENCES departments(id),
    FOREIGN key(job_id) REFERENCES jobs(id)
);

CREATE VIEW v_hired_by_quarter(department, job, "Q1", "Q2", "Q3", "Q4") AS
SELECT  COALESCE(d.department, 'N/D') department, COALESCE(j.job, 'N/D') job, 
SUM(CASE WHEN EXTRACT('QUARTER' FROM datetime) = 1 THEN 1 ELSE 0 END) "Q1",
SUM(CASE WHEN EXTRACT('QUARTER' FROM datetime) = 2 THEN 1 ELSE 0 END) "Q2",
SUM(CASE WHEN EXTRACT('QUARTER' FROM datetime) = 3 THEN 1 ELSE 0 END) "Q3",
SUM(CASE WHEN EXTRACT('QUARTER' FROM datetime) = 4 THEN 1 ELSE 0 END) "Q4"
FROM hired_employees h LEFT JOIN departments d
ON h.department_id = d.id
LEFT JOIN jobs j
ON h.job_id = j.id
WHERE date_part('YEAR', datetime) = 2021
GROUP BY d.department, j.job
ORDER BY 1, 2;

CREATE VIEW v_hired_by_department(id, department, hired) AS
SELECT COALESCE(d.id, -1) id, COALESCE(d.department, 'N/D') department, COUNT(*) hired
FROM hired_employees h LEFT JOIN departments d
ON h.department_id = d.id
WHERE date_part('YEAR', h.datetime) = 2021
GROUP BY d.id, d.department
ORDER BY hired DESC;

