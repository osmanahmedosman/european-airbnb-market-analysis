# European Airbnb Price Analysis

## Project Overview

This project analyzes Airbnb-related data across 10 European cities using SQL Server and Power BI. It explores price differences across cities, room types, and day types, alongside accommodation capacity, cleanliness ratings, guest satisfaction, and location-related factors.

The project demonstrates an end-to-end analytical workflow, from data preparation and validation in SQL Server to dimensional modeling, DAX measures, and interactive Power BI dashboards.

## Tools & Technologies

- **SQL Server:** Data storage, transformations, aggregations, data validation, and dimensional modeling.
- **Power BI:** Data modeling, DAX measures, interactive dashboards, and data visualization.
- **GitHub:** Version control, project documentation, and portfolio presentation.

## Dataset

The dataset covers 10 European cities:

Amsterdam, Athens, Barcelona, Berlin, Budapest, Lisbon, London, Paris, Rome, and Vienna.

**Source:** [Airbnb Prices in European Cities — Kaggle](https://www.kaggle.com/datasets/thedevastator/airbnb-prices-in-european-cities/code)

The original dataset files are stored locally and excluded from this repository.

## Data Architecture

The project follows a layered data architecture:

- **Bronze:** Imported source data, including a consolidated table.
- **Silver:** Consolidated data prepared for analysis.
- **Gold:** Aggregated analytical tables.
- **Star Schema:** A fact table connected to City, Room Type, and Day Type dimension tables for Power BI reporting.

## SQL Scripts

| File | Purpose |
|---|---|
| `01_Bronze.sql` | Source data consolidation |
| `02_Silver.sql` | Silver layer preparation |
| `03_Gold.sql` | Analytical aggregation tables |
| `04_StarSchema.sql` | Fact and dimension tables |
| `05_Validation.sql` | Data quality and row-count checks |

## Data Validation Results

The SQL validation checks confirmed the following:

- **51,707 records** in the Bronze layer.
- **51,707 records** in the Silver layer.
- **51,707 records** in the Fact table.
- **10 cities**, **3 room types**, and **2 day types** in the dimension tables.
- No missing values were found in the checked key analytical columns.
- No non-positive prices were detected.

These checks confirm row-count consistency across the tested layers. They do not independently establish that every source record represents a unique property listing.

## Power BI Dashboard

The Power BI report provides interactive views of price patterns and accommodation characteristics across the selected cities.

### Page 1 — Price Analysis

Explores average prices across cities and room types, compares weekday and weekend prices, and provides interactive filters for exploring the data.

![Power BI — Price Analysis](powerbi/screenshots/page1_price_analysis.png)

### Page 2 — City Insights

Examines the relationship between cleanliness ratings and guest satisfaction, room type distribution across cities, and average bedroom counts by room type. Additional KPI cards and slicers support further exploration.

![Power BI — City Insights](powerbi/screenshots/page2_city_insights.png)

### Key Analytical Areas

- Average price comparisons across cities and room types.
- Weekday versus weekend price comparisons.
- Accommodation capacity and room type distribution.
- Cleanliness ratings and guest satisfaction.
- Distance from city centers and metro stations.
- Interactive filtering by city, room type, day type, person capacity, and guest satisfaction.

## Project Structure

```text
Airbnb-European-Cities-Analysis/
├── sql/
│   ├── 01_Bronze.sql
│   ├── 02_Silver.sql
│   ├── 03_Gold.sql
│   ├── 04_StarSchema.sql
│   └── 05_Validation.sql
├── powerbi/
│   ├── Airbnb_Analysis.pbix
│   └── screenshots/
│       ├── page1_price_analysis.png
│       └── page2_city_insights.png
├── README.md
└── .gitignore
```

The raw dataset is excluded from version control.

