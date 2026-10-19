
--Bronze layer.


USE AirbnbProject;
GO

-- 1. Create the required schemas

IF SCHEMA_ID(N'Bronze') IS NULL
    EXEC(N'CREATE SCHEMA Bronze');

IF SCHEMA_ID(N'Silver') IS NULL
    EXEC(N'CREATE SCHEMA Silver');

IF SCHEMA_ID(N'Gold') IS NULL
    EXEC(N'CREATE SCHEMA Gold');
GO


-- 2. Move the 20 raw tables into the Bronze schema

IF OBJECT_ID(N'dbo.Bronze_Amsterdam_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Amsterdam_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Amsterdam_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Amsterdam_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Amsterdam_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Amsterdam_Weekends;

IF OBJECT_ID(N'dbo.Bronze_Athens_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Athens_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Athens_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Athens_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Athens_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Athens_Weekends;

IF OBJECT_ID(N'dbo.Bronze_Barcelona_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Barcelona_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Barcelona_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Barcelona_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Barcelona_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Barcelona_Weekends;

IF OBJECT_ID(N'dbo.Bronze_Berlin_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Berlin_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Berlin_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Berlin_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Berlin_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Berlin_Weekends;

IF OBJECT_ID(N'dbo.Bronze_Budapest_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Budapest_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Budapest_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Budapest_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Budapest_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Budapest_Weekends;

IF OBJECT_ID(N'dbo.Bronze_Lisbon_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Lisbon_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Lisbon_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Lisbon_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Lisbon_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Lisbon_Weekends;

IF OBJECT_ID(N'dbo.Bronze_London_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_London_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_London_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_London_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_London_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_London_Weekends;

IF OBJECT_ID(N'dbo.Bronze_Paris_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Paris_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Paris_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Paris_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Paris_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Paris_Weekends;

IF OBJECT_ID(N'dbo.Bronze_Rome_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Rome_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Rome_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Rome_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Rome_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Rome_Weekends;

IF OBJECT_ID(N'dbo.Bronze_Vienna_Weekdays', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Vienna_Weekdays', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Vienna_Weekdays;

IF OBJECT_ID(N'dbo.Bronze_Vienna_Weekends', N'U') IS NOT NULL
   AND OBJECT_ID(N'Bronze.Bronze_Vienna_Weekends', N'U') IS NULL
    ALTER SCHEMA Bronze TRANSFER dbo.Bronze_Vienna_Weekends;
GO


-- 3. Combine the 20 datasets into one table

IF OBJECT_ID(N'Bronze.Bronze_Airbnb_All', N'U') IS NULL
BEGIN
    SELECT *
    INTO Bronze.Bronze_Airbnb_All
    FROM
    (
        SELECT *, CAST('Amsterdam' AS VARCHAR(20)) AS City,
                  CAST('Weekday' AS VARCHAR(10)) AS DayType
        FROM Bronze.Bronze_Amsterdam_Weekdays

        UNION ALL
        SELECT *, 'Amsterdam', 'Weekend'
        FROM Bronze.Bronze_Amsterdam_Weekends

        UNION ALL
        SELECT *, 'Athens', 'Weekday'
        FROM Bronze.Bronze_Athens_Weekdays

        UNION ALL
        SELECT *, 'Athens', 'Weekend'
        FROM Bronze.Bronze_Athens_Weekends

        UNION ALL
        SELECT *, 'Barcelona', 'Weekday'
        FROM Bronze.Bronze_Barcelona_Weekdays

        UNION ALL
        SELECT *, 'Barcelona', 'Weekend'
        FROM Bronze.Bronze_Barcelona_Weekends

        UNION ALL
        SELECT *, 'Berlin', 'Weekday'
        FROM Bronze.Bronze_Berlin_Weekdays

        UNION ALL
        SELECT *, 'Berlin', 'Weekend'
        FROM Bronze.Bronze_Berlin_Weekends

        UNION ALL
        SELECT *, 'Budapest', 'Weekday'
        FROM Bronze.Bronze_Budapest_Weekdays

        UNION ALL
        SELECT *, 'Budapest', 'Weekend'
        FROM Bronze.Bronze_Budapest_Weekends

        UNION ALL
        SELECT *, 'Lisbon', 'Weekday'
        FROM Bronze.Bronze_Lisbon_Weekdays

        UNION ALL
        SELECT *, 'Lisbon', 'Weekend'
        FROM Bronze.Bronze_Lisbon_Weekends

        UNION ALL
        SELECT *, 'London', 'Weekday'
        FROM Bronze.Bronze_London_Weekdays

        UNION ALL
        SELECT *, 'London', 'Weekend'
        FROM Bronze.Bronze_London_Weekends

        UNION ALL
        SELECT *, 'Paris', 'Weekday'
        FROM Bronze.Bronze_Paris_Weekdays

        UNION ALL
        SELECT *, 'Paris', 'Weekend'
        FROM Bronze.Bronze_Paris_Weekends

        UNION ALL
        SELECT *, 'Rome', 'Weekday'
        FROM Bronze.Bronze_Rome_Weekdays

        UNION ALL
        SELECT *, 'Rome', 'Weekend'
        FROM Bronze.Bronze_Rome_Weekends

        UNION ALL
        SELECT *, 'Vienna', 'Weekday'
        FROM Bronze.Bronze_Vienna_Weekdays

        UNION ALL
        SELECT *, 'Vienna', 'Weekend'
        FROM Bronze.Bronze_Vienna_Weekends
    ) AS AllData;
END;
GO


-- 4. Validate the combined dataset

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT City) AS TotalCities
FROM Bronze.Bronze_Airbnb_All;

SELECT
    City,
    DayType,
    COUNT(*) AS TotalRows
FROM Bronze.Bronze_Airbnb_All
GROUP BY City, DayType
ORDER BY City, DayType;

SELECT
    City,
    DayType,
    AVG(realSum) AS AveragePrice
FROM Bronze.Bronze_Airbnb_All
GROUP BY City, DayType
ORDER BY City, DayType;
GO
