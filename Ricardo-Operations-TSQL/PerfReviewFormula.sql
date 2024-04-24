SET NOCOUNT ON
SELECT '2023' AS [YEAR], (2.40/3.0)*5 AS Rating
SELECT '2022' AS [YEAR], (2.44/3.0)*5 AS Rating -- John
SELECT '2021' AS [YEAR], (2.81/3.0)*5 AS Rating -- Kenny
SELECT '2020' AS [YEAR], (3.57/4.0)*5 AS Rating 
SELECT '2019' AS [YEAR], (4.36/5.0)*5 AS Rating
SELECT '2018' AS [YEAR], (4.36/5.0)*5 AS Rating
SELECT '2017' AS [YEAR], (4.36/5.0)*5 AS Rating
SELECT '2016' AS [YEAR], (4.36/5.0)*5 AS Rating

/*
The calculation for the Merit Increase is as follows:
*Proration/Service Factor = Team Member’s Number of Days in Active 
IEHP Employment Status during the Performance Review Period divided 
by 365
*/
YEAR Rating
---- ---------------------------------------
2023 4.000000

YEAR Rating
---- ---------------------------------------
2022 4.066665

YEAR Rating
---- ---------------------------------------
2021 4.683330

YEAR Rating
---- ---------------------------------------
2020 4.462500

YEAR Rating
---- ---------------------------------------
2019 4.500000


Completion time: 2024-01-04T12:10:54.3460719-08:00
