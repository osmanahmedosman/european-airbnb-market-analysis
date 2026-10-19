
-- Gold layer

USE AirbnbProject;
GO

-- 1.Compare average prices on weekdays and weekends

IF OBJECT_ID(N'Gold.Gold_CityPriceComparison', N'U') IS NULL
BEGIN
    SELECT
        City,
        ROUND(
            AVG(CASE WHEN DayType = 'Weekday' THEN realSum END), 2
        ) AS WeekdayAvgPrice,
        ROUND(
            AVG(CASE WHEN DayType = 'Weekend' THEN realSum END), 2
        ) AS WeekendAvgPrice,
        ROUND(
            AVG(CASE WHEN DayType = 'Weekend' THEN realSum END)
            - AVG(CASE WHEN DayType = 'Weekday' THEN realSum END), 2
        ) AS PriceDifference
    INTO Gold.Gold_CityPriceComparison
    FROM Silver.Silver_Airbnb
    GROUP BY City;
END;
GO

-- 2. Compare average prices by city and room type

IF OBJECT_ID(N'Gold.Gold_CityRoomTypeSummary', N'U') IS NULL
BEGIN
    SELECT
        City,
        room_type,
        COUNT(*) AS ListingsCount,
        ROUND(AVG(realSum), 2) AS AvgPrice
    INTO Gold.Gold_CityRoomTypeSummary
    FROM Silver.Silver_Airbnb
    GROUP BY City, room_type;
END;
GO

-- 3. Compare prices by city and person capacity

IF OBJECT_ID(N'Gold.Gold_CityCapacitySummary', N'U') IS NULL
BEGIN
    SELECT
        City,
        person_capacity,
        COUNT(*) AS ListingsCount,
        ROUND(AVG(realSum), 2) AS AvgPrice
    INTO Gold.Gold_CityCapacitySummary
    FROM Silver.Silver_Airbnb
    GROUP BY City, person_capacity;
END;
GO

-- 4.Compare prices by city, room type, and day type

IF OBJECT_ID(N'Gold.Gold_CityRoomTypeDayType', N'U') IS NULL
BEGIN
    SELECT
        City,
        room_type,
        DayType,
        COUNT(*) AS ListingsCount,
        ROUND(AVG(realSum), 2) AS AvgPrice
    INTO Gold.Gold_CityRoomTypeDayType
    FROM Silver.Silver_Airbnb
    GROUP BY City, room_type, DayType;
END;
GO

-- Display the Gold tables

SELECT *
FROM Gold.Gold_CityPriceComparison
ORDER BY City;

SELECT *
FROM Gold.Gold_CityRoomTypeSummary
ORDER BY City, room_type;

SELECT *
FROM Gold.Gold_CityCapacitySummary
ORDER BY City, person_capacity;

SELECT *
FROM Gold.Gold_CityRoomTypeDayType
ORDER BY City, room_type, DayType;
GO

-- Validate row counts between Silver and Gold summaries
-- Each Gold summary should account for all Silver rows when its ListingsCount values are summed

SELECT
    (SELECT COUNT(*) FROM Silver.Silver_Airbnb) AS SilverRows,
    (SELECT SUM(ListingsCount)
     FROM Gold.Gold_CityRoomTypeSummary) AS GoldRows;

SELECT
    (SELECT COUNT(*) FROM Silver.Silver_Airbnb) AS SilverRows,
    (SELECT SUM(ListingsCount)
     FROM Gold.Gold_CityCapacitySummary) AS GoldRows;

SELECT
    (SELECT COUNT(*) FROM Silver.Silver_Airbnb) AS SilverRows,
    (SELECT SUM(ListingsCount)
     FROM Gold.Gold_CityRoomTypeDayType) AS GoldRows;
GO
