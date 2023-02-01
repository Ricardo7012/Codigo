-- List Base Table in SQL Database

SELECT * FROM information_schema.tables
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME