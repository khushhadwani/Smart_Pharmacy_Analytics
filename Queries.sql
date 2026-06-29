USE pharmacy_analytics;

Business Question: Which patients generate recurring business?

SELECT patientID,
       CONCAT(firstName,' ',lastName) AS patient_name,
       COUNT(*) AS prescription_count
FROM pharmacy_data
GROUP BY patientID, patient_name
HAVING COUNT(*) > 1
ORDER BY prescription_count DESC;


Business Question: Which medicines require refill monitoring?

SELECT brandName,
       SUM(refills) AS total_refills
FROM pharmacy_data
GROUP BY brandName
ORDER BY total_refills DESC;


Business Question: Which medicines need pricing or supplier review?

SELECT brandName,
       SUM(revenue) AS revenue,
       SUM(profit) AS profit,
       ROUND((SUM(profit)/SUM(revenue))*100,2) AS margin_percent
FROM pharmacy_data
GROUP BY brandName
ORDER BY revenue DESC;


Business Question: Are we dependent on a single supplier?

SELECT name_supplier,
       SUM(revenue) AS revenue,
       ROUND(
       SUM(revenue)*100/
       (SELECT SUM(revenue) FROM pharmacy_data),
       2
       ) AS contribution_percent
FROM pharmacy_data
GROUP BY name_supplier
ORDER BY revenue DESC;


Business Question: Which doctors contribute the highest prescription revenue?

SELECT name,
       COUNT(*) AS prescriptions,
       SUM(revenue) AS revenue
FROM pharmacy_data
GROUP BY name
ORDER BY revenue DESC;


Business Question: Which medicines are most important for the business?

SELECT brandName,
       SUM(revenue) AS revenue,
       RANK() OVER(
       ORDER BY SUM(revenue) DESC
       ) AS revenue_rank
FROM pharmacy_data
GROUP BY brandName;


Business Question: Who are the VIP customers?

SELECT CONCAT(firstName,' ',lastName) AS patient_name,
       SUM(revenue) AS revenue,
       RANK() OVER(
       ORDER BY SUM(revenue) DESC
       ) AS customer_rank
FROM pharmacy_data
GROUP BY patient_name;


Business Question: Which insurance plans contribute higher-value prescriptions?

SELECT insurance,
       ROUND(AVG(revenue),2) AS avg_prescription_value
FROM pharmacy_data
GROUP BY insurance
ORDER BY avg_prescription_value DESC;


Business Question: Which prescriptions are most profitable?

SELECT brandName,
       revenue,
       profit,
       ROUND((profit/revenue)*100,2) AS margin_percent
FROM pharmacy_data
ORDER BY margin_percent DESC;


Business Question: Categorize medicines based on profitability.

SELECT brandName,
       ROUND((profit/revenue)*100,2) AS margin_percent,
       CASE
            WHEN (profit/revenue)*100 >= 30 THEN 'High Margin'
            WHEN (profit/revenue)*100 >= 15 THEN 'Medium Margin'
            ELSE 'Low Margin'
       END AS margin_category
FROM pharmacy_data;
