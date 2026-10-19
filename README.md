# European Airbnb Price Analysis

## Project Overview
This project analyzes Airbnb-related data across 10 European cities using SQL Server and Power BI. The goal is to explore price differences across cities, room types, and day types, and present the findings through data analysis and interactive visualizations.

## Tools & Technologies
- **SQL Server:** Data storage, SQL transformations, aggregations, validation, and dimensional modeling.
- **Power BI:** Interactive dashboards and data visualization.
- **GitHub:** Project version control and documentation.

## Dataset
The project uses a dataset covering 10 European cities:
Amsterdam, Athens, Barcelona, Berlin, Budapest, Lisbon, London, Paris, Rome, and Vienna.

**Source:** [Airbnb Prices in European Cities — Kaggle](https://www.kaggle.com/datasets/thedevastator/airbnb-prices-in-european-cities/code)

The raw data files are kept locally and are not included in this repository.

## Data Architecture
The project follows a layered structure:

- **Bronze:** Imported source data, including a combined table.
- **Silver:** Consolidated data used for analysis.
- **Gold:** Aggregated tables prepared for analytical queries.
- **Star Schema:** A fact table connected to City, Room Type, and Day Type dimensions for Power BI reporting.

## SQL Scripts
| File | Purpose |
|---|---|
| `01_Bronze.sql` | Source data consolidation |
| `02_Silver.sql` | Silver layer preparation |
| `03_Gold.sql` | Analytical aggregation tables |
| `04_StarSchema.sql` | Fact and dimension tables |
| `05_Validation.sql` | Data quality and row-count checks |

## Validation Results
- 51,707 records in the Bronze layer.
- 51,707 records in the Silver layer.
- 51,707 records in the Fact table.
- 10 cities, 3 room types, and 2 day types.
- No missing values in the checked key columns.
- No non-positive prices were detected.

These checks confirm row-count consistency across the tested layers; they do not independently establish that every source record represents a unique property.

## Power BI Dashboard
The `powerbi/` folder will contain the final Power BI report and related project assets.

Planned analysis includes:
- Price comparisons across cities.
- Price analysis by room type.
- Weekday versus weekend comparisons.
- Interactive filters for exploring the data.

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
├── README.md
└── .gitignore
```

## Disclaimer
The dataset's price unit and the uniqueness of individual property listings should be confirmed from the original dataset documentation before making claims about absolute prices or unique listing counts.
