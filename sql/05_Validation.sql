
-- Validate data layers and analytical tables

USE AirbnbProject;
GO

-- 1. Validate row counts across the main data layers

SELECT
    'Bronze' AS DataLayer,
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT City) AS TotalCities
FROM Bronze.Bronze_Airbnb_All

UNION ALL

SELECT
    'Silver',
    COUNT(*),
    COUNT(DISTINCT City)
FROM Silver.Silver_Airbnb;
GO


-- 2. Validate row counts by city and day type

SELECT
    City,
    DayType,
    COUNT(*) AS TotalRows
FROM Silver.Silver_Airbnb
GROUP BY City, DayType
ORDER BY City, DayType;
GO


-- 3. Check missing values in important columns

SELECT
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS MissingCity,
    SUM(CASE WHEN DayType IS NULL THEN 1 ELSE 0 END) AS MissingDayType,
    SUM(CASE WHEN room_type IS NULL THEN 1 ELSE 0 END) AS MissingRoomType,
    SUM(CASE WHEN realSum IS NULL THEN 1 ELSE 0 END) AS MissingPrice,
    SUM(CASE WHEN person_capacity IS NULL THEN 1 ELSE 0 END)
        AS MissingCapacity
FROM Silver.Silver_Airbnb;
GO


-- 4. Check invalid or non-positive prices

SELECT COUNT(*) AS InvalidPriceRows
FROM Silver.Silver_Airbnb
WHERE realSum <= 0;
GO


-- 5. Validate Gold summary row counts

SELECT
    'Gold_CityRoomTypeSummary' AS SummaryTable,
    (SELECT COUNT(*) FROM Silver.Silver_Airbnb) AS SilverRows,
    (SELECT SUM(ListingsCount)
     FROM Gold.Gold_CityRoomTypeSummary) AS GoldRows

UNION ALL

SELECT
    'Gold_CityCapacitySummary',
    (SELECT COUNT(*) FROM Silver.Silver_Airbnb),
    (SELECT SUM(ListingsCount)
     FROM Gold.Gold_CityCapacitySummary)

UNION ALL

SELECT
    'Gold_CityRoomTypeDayType',
    (SELECT COUNT(*) FROM Silver.Silver_Airbnb),
    (SELECT SUM(ListingsCount)
     FROM Gold.Gold_CityRoomTypeDayType);
GO


-- 6. Check the Star Schema tables, if they exist

IF OBJECT_ID(N'Gold.DimCity', N'U') IS NOT NULL
   AND OBJECT_ID(N'Gold.DimRoomType', N'U') IS NOT NULL
   AND OBJECT_ID(N'Gold.DimDayType', N'U') IS NOT NULL
   AND OBJECT_ID(N'Gold.FactAirbnb', N'U') IS NOT NULL
BEGIN
    SELECT
        (SELECT COUNT(*) FROM Silver.Silver_Airbnb) AS SilverRows,
        (SELECT COUNT(*) FROM Gold.FactAirbnb) AS FactRows;

    SELECT
        (SELECT COUNT(*) FROM Gold.DimCity) AS CityDimensionRows,
        (SELECT COUNT(*) FROM Gold.DimRoomType) AS RoomTypeDimensionRows,
        (SELECT COUNT(*) FROM Gold.DimDayType) AS DayTypeDimensionRows;
END
ELSE
BEGIN
    PRINT 'Star Schema tables have not been created yet.';
END;
GO
