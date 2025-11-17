-- Project: HR_Analytics_Dawa
-- Purpose: Employee demographics, payroll, and performance analytics

-- 1. Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    JobTitle VARCHAR(50),
    DateHired DATE,
    BaseSalary DECIMAL(10,2),
    City VARCHAR(50)
);

INSERT INTO Employees (EmployeeID, EmployeeName, Department, JobTitle, DateHired, BaseSalary, City) VALUES
(1, 'Alice K.', 'Production', 'Production Manager', '2020-01-15', 120000, 'Nairobi'),
(2, 'Brian M.', 'Sales', 'Sales Executive', '2021-03-22', 90000, 'Mombasa'),
(3, 'Clara N.', 'Quality Control', 'QC Analyst', '2022-05-10', 80000, 'Kisumu'),
(4, 'David O.', 'R&D', 'Research Scientist', '2019-08-12', 150000, 'Nairobi'),
(5, 'Evelyn P.', 'HR', 'HR Officer', '2020-11-05', 85000, 'Nakuru');

-- 2. Performance table
CREATE TABLE Performance (
    EmployeeID INT,
    Year INT,
    KPI_Score DECIMAL(4,2),  -- out of 5
    Bonus DECIMAL(10,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Performance (EmployeeID, Year, KPI_Score, Bonus) VALUES
(1, 2024, 4.5, 15000),
(2, 2024, 4.0, 10000),
(3, 2024, 3.8, 8000),
(4, 2024, 4.7, 20000),
(5, 2024, 4.2, 12000);

-- =====================================================
-- HR Analytics Queries
-- =====================================================

-- 1. Salary distribution by department
SELECT 
    Department,
    COUNT(*) AS NumEmployees,
    AVG(BaseSalary) AS AvgSalary,
    MIN(BaseSalary) AS MinSalary,
    MAX(BaseSalary) AS MaxSalary
FROM Employees
GROUP BY Department
ORDER BY AvgSalary DESC;

-- 2. Top performers (KPI > 4.5)
SELECT 
    e.EmployeeName,
    e.Department,
    p.KPI_Score,
    p.Bonus
FROM Employees e
JOIN Performance p ON e.EmployeeID = p.EmployeeID
WHERE p.KPI_Score > 4.5
ORDER BY p.KPI_Score DESC;

-- 3. Total payroll per department
SELECT 
    Department,
    SUM(BaseSalary + COALESCE(p.Bonus, 0)) AS TotalPayroll
FROM Employees e
LEFT JOIN Performance p ON e.EmployeeID = p.EmployeeID
GROUP BY Department
ORDER BY TotalPayroll DESC;

-- 4. Employees hired per year
SELECT 
    YEAR(DateHired) AS HireYear,
    COUNT(*) AS NumHired
FROM Employees
GROUP BY YEAR(DateHired)
ORDER BY HireYear ASC;

-- 5. Bonus eligibility summary
SELECT 
    Department,
    COUNT(*) AS NumEligible,
    SUM(Bonus) AS TotalBonusPaid
FROM Employees e
JOIN Performance p ON e.EmployeeID = p.EmployeeID
WHERE p.KPI_Score >= 4.0
GROUP BY Department
ORDER BY TotalBonusPaid DESC;
