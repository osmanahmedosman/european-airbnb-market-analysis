
-- Check data quality and prepare the Silver dataset.

USE AirbnbProject;
GO

--  1. Check missing values in important columns

SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN realSum IS NULL THEN 1 ELSE 0 END) AS MissingPrices,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS MissingCities,
    SUM(CASE WHEN DayType IS NULL THEN 1 ELSE 0 END) AS MissingDayTypes,
    SUM(CASE WHEN lat IS NULL THEN 1 ELSE 0 END) AS MissingLatitude,
    SUM(CASE WHEN lng IS NULL THEN 1 ELSE 0 END) AS MissingLongitude
FROM Bronze.Bronze_Airbnb_All;


-- 2. Check missing values across all columns

DECLARE @SQL NVARCHAR(MAX) = N'';

SELECT @SQL = @SQL +
    CASE WHEN @SQL = N'' THEN N'' ELSE N' UNION ALL ' END +
    N'SELECT N''' + COLUMN_NAME + N''' AS ColumnName,
        COUNT(*) AS TotalRows,
        SUM(CASE WHEN ' + QUOTENAME(COLUMN_NAME) + N' IS NULL
            THEN 1 ELSE 0 END) AS MissingValues
      FROM Bronze.Bronze_Airbnb_All'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Bronze'
  AND TABLE_NAME = 'Bronze_Airbnb_All';

EXEC sys.sp_executesql @SQL;
GO


-- 3. Identify where longitude values are missing

SELECT
    City,
    DayType,
    COUNT(*) AS MissingLongitude
FROM Bronze.Bronze_Airbnb_All
WHERE lng IS NULL
GROUP BY City, DayType
ORDER BY City, DayType;

SELECT *
FROM Bronze.Bronze_Airbnb_All
WHERE City = 'London'
  AND lng IS NULL;


-- 4. Check for invalid prices

SELECT COUNT(*) AS InvalidPrices
FROM Bronze.Bronze_Airbnb_All
WHERE realSum <= 0;


-- 5. Identify potential duplicate records

SELECT
    realSum,
    room_type,
    room_shared,
    room_private,
    person_capacity,
    host_is_superhost,
    multi,
    biz,
    cleanliness_rating,
    guest_satisfaction_overall,
    bedrooms,
    dist,
    metro_dist,
    attr_index,
    attr_index_norm,
    rest_index,
    rest_index_norm,
    lng,
    lat,
    City,
    DayType,
    COUNT(*) AS Occurrences
FROM Bronze.Bronze_Airbnb_All
GROUP BY
    realSum,
    room_type,
    room_shared,
    room_private,
    person_capacity,
    host_is_superhost,
    multi,
    biz,
    cleanliness_rating,
    guest_satisfaction_overall,
    bedrooms,
    dist,
    metro_dist,
    attr_index,
    attr_index_norm,
    rest_index,
    rest_index_norm,
    lng,
    lat,
    City,
    DayType
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;


-- 6. Create the Silver table

IF OBJECT_ID(N'Silver.Silver_Airbnb', N'U') IS NULL
BEGIN
    SELECT *
    INTO Silver.Silver_Airbnb
    FROM Bronze.Bronze_Airbnb_All;
END;
GO


-- 7. Explore distinct values in categorical columns

SELECT DISTINCT room_type
FROM Silver.Silver_Airbnb
ORDER BY room_type;

SELECT DISTINCT DayType
FROM Silver.Silver_Airbnb
ORDER BY DayType;

SELECT DISTINCT City
FROM Silver.Silver_Airbnb
ORDER BY City;

SELECT DISTINCT room_shared
FROM Silver.Silver_Airbnb
ORDER BY room_shared;

SELECT DISTINCT room_private
FROM Silver.Silver_Airbnb
ORDER BY room_private;

SELECT DISTINCT host_is_superhost
FROM Silver.Silver_Airbnb
ORDER BY host_is_superhost;

SELECT DISTINCT multi
FROM Silver.Silver_Airbnb
ORDER BY multi;

SELECT DISTINCT biz
FROM Silver.Silver_Airbnb
ORDER BY biz;


-- 8. Summarize rows and average prices by city and day

SELECT
    City,
    DayType,
    COUNT(*) AS ListingsCount,
    ROUND(AVG(realSum), 2) AS AvgPrice
FROM Silver.Silver_Airbnb
GROUP BY City, DayType
ORDER BY City, DayType;
GO
