
-- Create a star schema for Power BI

USE AirbnbProject;
GO

-- 1. Create the City dimension

IF OBJECT_ID(N'Gold.DimCity', N'U') IS NULL
BEGIN
    CREATE TABLE Gold.DimCity
    (
        CityKey INT IDENTITY(1,1) PRIMARY KEY,
        City VARCHAR(50) NOT NULL UNIQUE
    );
END;
GO

-- 2. Create the Room Type dimension

IF OBJECT_ID(N'Gold.DimRoomType', N'U') IS NULL
BEGIN
    CREATE TABLE Gold.DimRoomType
    (
        RoomTypeKey INT IDENTITY(1,1) PRIMARY KEY,
        RoomType VARCHAR(50) NOT NULL UNIQUE
    );
END;
GO

-- 3. Create the Day Type dimension

IF OBJECT_ID(N'Gold.DimDayType', N'U') IS NULL
BEGIN
    CREATE TABLE Gold.DimDayType
    (
        DayTypeKey INT IDENTITY(1,1) PRIMARY KEY,
        DayType VARCHAR(20) NOT NULL UNIQUE
    );
END;
GO

-- 4. Create the fact table

IF OBJECT_ID(N'Gold.FactAirbnb', N'U') IS NULL
BEGIN
    CREATE TABLE Gold.FactAirbnb
    (
        FactAirbnbKey BIGINT IDENTITY(1,1) PRIMARY KEY,
        CityKey INT NOT NULL,
        RoomTypeKey INT NOT NULL,
        DayTypeKey INT NOT NULL,
        Price DECIMAL(18,2) NULL,
        PersonCapacity INT NULL,
        Bedrooms INT NULL,
        CleanlinessRating DECIMAL(10,2) NULL,
        GuestSatisfactionOverall DECIMAL(10,2) NULL,
        DistanceFromCenter DECIMAL(18,6) NULL,
        MetroDistance DECIMAL(18,6) NULL,

        FOREIGN KEY (CityKey)
            REFERENCES Gold.DimCity(CityKey),

        FOREIGN KEY (RoomTypeKey)
            REFERENCES Gold.DimRoomType(RoomTypeKey),

        FOREIGN KEY (DayTypeKey)
            REFERENCES Gold.DimDayType(DayTypeKey)
    );
END;
GO

-- 5. Populate dimensions when empty

IF NOT EXISTS (SELECT 1 FROM Gold.DimCity)
BEGIN
    INSERT INTO Gold.DimCity (City)
    SELECT DISTINCT City
    FROM Silver.Silver_Airbnb
    WHERE City IS NOT NULL;
END;
GO

IF NOT EXISTS (SELECT 1 FROM Gold.DimRoomType)
BEGIN
    INSERT INTO Gold.DimRoomType (RoomType)
    SELECT DISTINCT room_type
    FROM Silver.Silver_Airbnb
    WHERE room_type IS NOT NULL;
END;
GO

IF NOT EXISTS (SELECT 1 FROM Gold.DimDayType)
BEGIN
    INSERT INTO Gold.DimDayType (DayType)
    SELECT DISTINCT DayType
    FROM Silver.Silver_Airbnb
    WHERE DayType IS NOT NULL;
END;
GO

-- 6. Check for unmatched dimension values before loading

IF EXISTS
(
    SELECT 1
    FROM Silver.Silver_Airbnb AS s
    LEFT JOIN Gold.DimCity AS c
        ON s.City = c.City
    LEFT JOIN Gold.DimRoomType AS r
        ON s.room_type = r.RoomType
    LEFT JOIN Gold.DimDayType AS d
        ON s.DayType = d.DayType
    WHERE c.CityKey IS NULL
       OR r.RoomTypeKey IS NULL
       OR d.DayTypeKey IS NULL
)
BEGIN
    THROW 50001,
        'Some Silver records have no matching dimension values.',
        1;
END;
GO

-- 7. Load the fact table only when it is empty

IF NOT EXISTS (SELECT 1 FROM Gold.FactAirbnb)
BEGIN
    INSERT INTO Gold.FactAirbnb
    (
        CityKey,
        RoomTypeKey,
        DayTypeKey,
        Price,
        PersonCapacity,
        Bedrooms,
        CleanlinessRating,
        GuestSatisfactionOverall,
        DistanceFromCenter,
        MetroDistance
    )
    SELECT
        c.CityKey,
        r.RoomTypeKey,
        d.DayTypeKey,
        s.realSum,
        s.person_capacity,
        s.bedrooms,
        s.cleanliness_rating,
        s.guest_satisfaction_overall,
        s.dist,
        s.metro_dist
    FROM Silver.Silver_Airbnb AS s
    INNER JOIN Gold.DimCity AS c
        ON s.City = c.City
    INNER JOIN Gold.DimRoomType AS r
        ON s.room_type = r.RoomType
    INNER JOIN Gold.DimDayType AS d
        ON s.DayType = d.DayType;
END;
GO

-- 8. Validate source and fact row counts

SELECT
    (SELECT COUNT(*) FROM Silver.Silver_Airbnb) AS SilverRows,
    (SELECT COUNT(*) FROM Gold.FactAirbnb) AS FactRows;

SELECT * FROM Gold.DimCity ORDER BY City;
SELECT * FROM Gold.DimRoomType ORDER BY RoomType;
SELECT * FROM Gold.DimDayType ORDER BY DayType;
GO
