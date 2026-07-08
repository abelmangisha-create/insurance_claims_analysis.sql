/* ============================================================
   Insurance Claims Exploratory Analysis (SQL / SSMS)
   Dataset: insurance_dataset (Kaggle Insurance Claims Dataset)
   Same source data used in the R distribution-fitting project
   (see: Distribution Fitting on Insurance Claims Data (R))
   ============================================================ */

-- 1. Average age of policyholders by gender
SELECT
    Gender,
    AVG(Age) AS average_age_of_policyholders
FROM insurance_dataset
GROUP BY Gender
ORDER BY Gender;


-- 2. Youngest and oldest policyholder by gender
SELECT
    Gender,
    MAX(Age) AS oldest,
    MIN(Age) AS youngest
FROM insurance_dataset
GROUP BY Gender
ORDER BY Gender;


-- 3. Total claims and total income by gender
SELECT
    Gender,
    COUNT(Claim_Amount) AS total_claims,
    SUM(Income) AS total_income
FROM insurance_dataset
GROUP BY Gender
ORDER BY total_income DESC;


-- 4. Total income by marital status
SELECT
    Marital_Status,
    SUM(Income) AS total_income
FROM insurance_dataset
GROUP BY Marital_Status;


-- 5. Income analysis by occupation and marital status
SELECT
    Occupation,
    Marital_Status,
    AVG(Income) AS average_income,
    MAX(Income) AS highest_income,
    MIN(Income) AS lowest_income
FROM insurance_dataset
GROUP BY Occupation, Marital_Status
ORDER BY Occupation DESC;


-- 6. Income analysis by education level
SELECT
    Education,
    AVG(Income) AS average_income,
    MAX(Income) AS highest_income,
    MIN(Income) AS lowest_income
FROM insurance_dataset
GROUP BY Education;


-- 7. Claim count, average claim, and income range by gender
SELECT
    Gender,
    COUNT(Claim_Amount) AS total_claims,
    AVG(Claim_Amount) AS average_claim_amount,
    MAX(Claim_Amount) AS largest_claim,
    MIN(Claim_Amount) AS smallest_claim,
    MAX(Income) AS highest_income,
    MIN(Income) AS lowest_income
FROM insurance_dataset
GROUP BY Gender;


-- 8. Total claims by occupation and marital status
SELECT
    Occupation,
    Marital_Status,
    COUNT(Claim_Amount) AS total_claims
FROM insurance_dataset
GROUP BY Occupation, Marital_Status
ORDER BY Occupation;
