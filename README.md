# Delhi Metro Ridership & Revenue Analysis

An end-to-end data analytics project analyzing **150,000+ Delhi Metro trips** using **SQL and Power BI** to uncover insights into passenger trends, station performance, ticket types, metro lines, fares, distance, and revenue.

## Project Overview

This project combines SQL-based data analysis with an interactive Power BI dashboard to transform raw Delhi Metro trip data into meaningful business insights.

The analysis focuses on understanding ridership patterns, identifying high-performing stations and routes, analyzing ticket-type usage, and exploring fare and revenue trends.
## Tools & Technologies

- **SQL (MySQL)** — Data cleaning, transformation, analysis, aggregations, CTEs, and ranking
- **Power BI** — Interactive dashboard, KPI cards, charts, and slicers
- **Power Query** — Data preparation and transformation
- **GitHub** — Project documentation and portfolio

## Dataset

The project uses Delhi Metro trip and station datasets containing information such as:

- Trip date
- Origin and destination stations
- Distance travelled
- Fare
- Passenger count
- Ticket type
- Metro line
- Station details
- Station location and opening year
## Key Performance Indicators

| KPI | Value |
|---|---:|
| Total Trips | 150K |
| Total Passengers | 3M |
| Total Revenue | ₹312.28M |
| Average Fare | ₹105.12 |
| Average Distance | 5.49 km |

## Power BI Dashboard

The interactive dashboard provides a visual overview of Delhi Metro ridership and revenue through:

- Passenger volume by metro line
- Passenger volume by ticket type
- Passenger trends by year
- Top originating stations
- Interactive Year and Ticket Type slicers
## SQL Analysis

The dataset was analyzed using MySQL to answer key business and operational questions, including:

- Overall trip, passenger, distance, and fare statistics
- Top originating and destination stations
- Most frequently used routes
- Passenger volume by metro line and ticket type
- Distance and fare analysis
- Yearly and monthly passenger trends
- Highest and lowest passenger-volume days
- Passenger and fare analysis by trip remarks
- Ranking stations based on combined passenger volume
- Data quality and missing-value analysis

SQL techniques used include:

- Aggregations (`COUNT`, `SUM`, `AVG`)
- `GROUP BY` and `ORDER BY`
- Filtering and data cleaning
- `JOIN`s
- Common Table Expressions (CTEs)
- Window functions and ranking
## Key Insights

- The dataset contains **150,000 trips** and approximately **3 million passengers**.
- Total calculated revenue is approximately **₹312.28 million**.
- Passenger volume remained relatively stable across **2022–2024**, with 2024 recording the highest annual passenger volume.
- **August** recorded the highest monthly passenger volume, while **February** recorded the lowest.
- **Rajiv Chowk** recorded the highest combined passenger volume among the analyzed stations.
- **Tourist Card** was the most frequently used ticket type in the dataset.
- Most trips fell within the **short-distance category**, indicating a strong concentration of shorter journeys.
- SQL-based station and route analysis helped identify high-volume locations and commonly used travel patterns.
## Project Workflow

1. **Data Collection** — Collected Delhi Metro trip and station datasets.
2. **Data Cleaning** — Identified and handled missing values, inconsistent station names, duplicate station records, and formatting issues.
3. **SQL Analysis** — Performed exploratory and analytical queries using MySQL to identify passenger, station, route, fare, distance, and revenue patterns.
4. **Power BI Preparation** — Imported the cleaned data and established the required data relationships.
5. **Dashboard Development** — Built an interactive Power BI dashboard with KPI cards, charts, and slicers.
6. **Insight Generation** — Used the analysis and dashboard to identify key ridership and revenue patterns.
## Dashboard Preview

The Power BI dashboard provides an interactive view of Delhi Metro ridership and revenue performance, allowing users to explore passenger trends, metro lines, ticket types, and station-level performance using interactive filters.
<img width="1442" height="803" alt="Dashboard png" src="https://github.com/user-attachments/assets/f6f7cb39-1a1e-4a5d-9b04-7aa496ab8fb0" />

## Future Enhancements

- Add additional external factors such as holidays, weather, or special events to study their impact on ridership.
- Develop more advanced Power BI measures and time-intelligence analysis.
- Explore predictive analytics for passenger demand forecasting.
- Analyze route-level congestion and peak travel patterns in greater detail.
- Add geographic visualizations for station-level spatial analysis.
## Author

**Divyanshi Tiwari**

Aspiring Data Analyst passionate about transforming data into meaningful insights through analysis, visualization, and data-driven problem solving.

- **LinkedIn:** [Divyanshi Tiwari](https://www.linkedin.com/in/divyanshi-tiwari-4250402a0/)
