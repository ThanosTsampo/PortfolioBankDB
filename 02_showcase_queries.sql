USE PortfolioBankDB;
GO
-- -----------------------------------------------------------------
-- QUERY 1: Customer Portfolio Summary
-- Methods/Commands: LEFT JOIN, GROUP BY, SUM(), COUNT(), ISNULL()
-- -----------------------------------------------------------------
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(a.account_id) AS total_accounts,
    ISNULL(SUM(a.balance), 0.00) AS total_balance
FROM dbo.Customers c
LEFT JOIN dbo.Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_balance DESC;

-- -----------------------------------------------------------------
-- QUERY 2: High-Value Loans via Subquery
-- Methods/Commands: INNER JOIN, WHERE, Subquery (IN)
-- -----------------------------------------------------------------
SELECT 
    c.customer_id,
    c.customer_name,
    p.product_id,
    p.amount AS loan_amount
FROM dbo.Customers c
JOIN dbo.Products p ON c.customer_id = p.customer_id
WHERE p.type = 'Loan' 
  AND p.customer_id IN (
      SELECT customer_id 
      FROM dbo.Products 
      WHERE status = 'Active' AND amount > 10000.00
  )
ORDER BY p.amount DESC;

-- -----------------------------------------------------------------
-- QUERY 3: Transaction Risk Flagging (AML Compliance)
-- Methods/Commands: CASE WHEN (Flagging), ORDER BY
-- -----------------------------------------------------------------
SELECT 
    t.transaction_id,
    t.account_id,
    t.transaction_date,
    t.amount,
    CASE WHEN t.amount >= 5000.00 THEN 1 ELSE 0 END AS is_large_transaction,
    CASE 
        WHEN t.amount >= 10000.00 THEN 'HIGH'
        WHEN t.amount >= 3000.00  THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_level
FROM dbo.Transactions t
ORDER BY t.amount DESC;

-- -----------------------------------------------------------------
-- QUERY 4: Account Balance Ranking per Type via CTE
-- Methods/Commands: CTE (WITH), DENSE_RANK() OVER (PARTITION BY), INNER JOIN
-- -----------------------------------------------------------------
WITH RankedAccounts AS (
    SELECT 
        account_id,
        customer_id,
        account_type,
        balance,
        DENSE_RANK() OVER (PARTITION BY account_type ORDER BY balance DESC) AS rank_in_type
    FROM dbo.Accounts
)
SELECT 
    ra.account_id,
    c.customer_name,
    ra.account_type,
    ra.balance,
    ra.rank_in_type
FROM RankedAccounts ra
JOIN dbo.Customers c ON ra.customer_id = c.customer_id;

-- -----------------------------------------------------------------
-- QUERY 5: Running Balance per Account
-- Methods/Commands: SUM() OVER (PARTITION BY ORDER BY), CASE WHEN
-- -----------------------------------------------------------------
SELECT 
    t.account_id,
    t.transaction_id,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    SUM(CASE WHEN t.transaction_type = 'Deposit' THEN t.amount ELSE -t.amount END) 
        OVER (PARTITION BY t.account_id ORDER BY t.transaction_date, t.transaction_id) AS running_balance
FROM dbo.Transactions t
ORDER BY t.account_id, t.transaction_date;