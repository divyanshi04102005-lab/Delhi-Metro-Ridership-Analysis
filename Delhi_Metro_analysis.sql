```sql
/* ============================================================
   DELHI METRO SQL PROJECT
   SQL ANALYSIS, DATA CLEANING & BUSINESS INSIGHTS

   Database  : MySQL
   Project   : Delhi Metro Ridership & Revenue Analysis

   Purpose:
   - Create and prepare the Delhi Metro database
   - Import and validate trip and station data
   - Perform data cleaning and quality checks
   - Analyze passenger volume, fares, routes and stations
   - Generate insights using aggregations, CTEs and
     window functions
   ============================================================ */


/* ============================================================
   1. DATABASE & TABLE CREATION
   ============================================================ */

CREATE DATABASE Delhi_Metro_Project;

USE Delhi_Metro_Project;


/* -------------------- Stations Table -------------------- */

CREATE TABLE stations (
    stations_id INT,
    station_name VARCHAR(100),
    distance_from_first_station DECIMAL(10,2),
    metro_line VARCHAR(100),
    opened_year VARCHAR(20),
    layout VARCHAR(50),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7)
);


/* -------------------- Trips Table -------------------- */

CREATE TABLE trips (
    trip_id INT,
    trip_date DATE,
    from_station VARCHAR(100),
    to_station VARCHAR(100),
    distance_km DECIMAL(10,2),
    fare DECIMAL(10,2),
    cost_per_passenger DECIMAL(10,2),
    passenger VARCHAR(20),
    ticket_type VARCHAR(50),
    remarks VARCHAR(100)
);


/* ============================================================
   2. INITIAL DATA VALIDATION
   ============================================================ */

SELECT COUNT(*) AS total_station_rows
FROM stations;

SELECT COUNT(*) AS total_trip_rows
FROM trips;

SHOW TABLES;


/* ============================================================
   3. MYSQL FILE IMPORT CONFIGURATION
   ============================================================ */

SET GLOBAL local_infile = 1;


/* ============================================================
   4. IMPORT TRIPS DATA
   ============================================================ */

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/delhi_metro_trips.csv'
INTO TABLE trips
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    trip_id,
    @trip_date,
    from_station,
    to_station,
    distance_km,
    fare,
    cost_per_passenger,
    @passenger,
    ticket_type,
    remarks
)
SET
    trip_date = STR_TO_DATE(@trip_date, '%d-%m-%Y'),
    passenger = NULLIF(@passenger, '');


/* ============================================================
   5. TRIPS DATA QUALITY CHECK
   ============================================================ */

DESCRIBE trips;

SELECT
    COUNT(*) AS total_rows,
    SUM(trip_id IS NULL) AS missing_trip_id,
    SUM(trip_date IS NULL) AS missing_date,
    SUM(from_station IS NULL OR TRIM(from_station) = '')
        AS missing_from_station,
    SUM(to_station IS NULL OR TRIM(to_station) = '')
        AS missing_to_station,
    SUM(distance_km IS NULL) AS missing_distance,
    SUM(fare IS NULL) AS missing_fare,
    SUM(cost_per_passenger IS NULL) AS missing_cost,
    SUM(passenger IS NULL OR TRIM(passenger) = '')
        AS missing_passenger,
    SUM(ticket_type IS NULL OR TRIM(ticket_type) = '')
        AS missing_ticket_type,
    SUM(remarks IS NULL OR TRIM(remarks) = '')
        AS missing_remarks
FROM trips;


/* ============================================================
   6. MISSING PASSENGER & TICKET TYPE ANALYSIS
   ============================================================ */

SELECT
    SUM(
        (passenger IS NULL OR TRIM(passenger) = '')
        AND
        (ticket_type IS NULL OR TRIM(ticket_type) = '')
    ) AS missing_both
FROM trips;

SELECT
    passenger,
    ticket_type,
    COUNT(*) AS count_rows
FROM trips
WHERE passenger IS NULL
   OR TRIM(passenger) = ''
   OR ticket_type IS NULL
   OR TRIM(ticket_type) = ''
GROUP BY passenger, ticket_type
ORDER BY count_rows DESC;


/* ============================================================
   7. TRIP ID DUPLICATE CHECK
   ============================================================ */

SELECT
    trip_id,
    COUNT(*) AS count_rows
FROM trips
GROUP BY trip_id
HAVING COUNT(*) > 1;


/* ============================================================
   8. PASSENGER DATA VALIDATION
   ============================================================ */

SELECT
    passenger,
    COUNT(*) AS count_rows
FROM trips
WHERE passenger IS NOT NULL
  AND TRIM(passenger) <> ''
GROUP BY passenger
ORDER BY CAST(passenger AS UNSIGNED);

SELECT
    MIN(CAST(passenger AS UNSIGNED)) AS minimum_passenger,
    MAX(CAST(passenger AS UNSIGNED)) AS maximum_passenger,
    COUNT(DISTINCT passenger) AS unique_passengers
FROM trips
WHERE passenger IS NOT NULL
  AND TRIM(passenger) <> '';


/* ============================================================
   9. STATIONS DATA QUALITY CHECK
   ============================================================ */

SELECT
    SUM(stations_id IS NULL) AS missing_station_id,
    SUM(station_name IS NULL OR TRIM(station_name) = '')
        AS missing_station_name,
    SUM(distance_from_first_station IS NULL)
        AS missing_distance,
    SUM(metro_line IS NULL OR TRIM(metro_line) = '')
        AS missing_metro_line,
    SUM(opened_year IS NULL) AS missing_opened_year,
    SUM(layout IS NULL OR TRIM(layout) = '')
        AS missing_layout,
    SUM(latitude IS NULL) AS missing_latitude,
    SUM(longitude IS NULL) AS missing_longitude
FROM stations;


/* ============================================================
   10. STATION DUPLICATE & ID VALIDATION
   ============================================================ */

SELECT
    station_name,
    COUNT(*) AS count_rows
FROM stations
GROUP BY station_name
HAVING COUNT(*) > 1
ORDER BY count_rows DESC;


/*
   The following stations were checked because duplicate
   station names can represent legitimate branch/main entries.
*/

SELECT *
FROM stations
WHERE station_name IN ('Yamuna Bank', 'Ashok Park Main');


SELECT
    stations_id,
    COUNT(*) AS count_rows
FROM stations
GROUP BY stations_id
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_station_rows,
    COUNT(DISTINCT station_name) AS unique_station_names,
    COUNT(DISTINCT stations_id) AS unique_station_ids
FROM stations;


/* ============================================================
   11. STATION NAME CLEANING
   ============================================================ */

SET SQL_SAFE_UPDATES = 0;

UPDATE stations
SET station_name = TRIM(station_name)
WHERE LENGTH(station_name) > LENGTH(TRIM(station_name));


/* ============================================================
   12. METRO LINE ANALYSIS
   ============================================================ */

SELECT
    metro_line,
    COUNT(*) AS count_rows
FROM stations
GROUP BY metro_line
ORDER BY count_rows DESC;


/* ============================================================
   13. STATION OPENING YEAR ANALYSIS
   ============================================================ */

SELECT
    opened_year,
    COUNT(*) AS count_rows
FROM stations
GROUP BY opened_year
ORDER BY opened_year
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT opened_year) AS unique_opening_dates
FROM stations;

SELECT
    opened_year
FROM stations
WHERE opened_year NOT REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';


/* ============================================================
   14. STATION LAYOUT ANALYSIS
   ============================================================ */

SELECT
    layout,
    COUNT(*) AS count_rows
FROM stations
GROUP BY layout
ORDER BY count_rows DESC;


/* ============================================================
   15. STATION COORDINATE VALIDATION
   ============================================================ */

SELECT
    MIN(latitude) AS min_latitude,
    MAX(latitude) AS max_latitude,
    MIN(longitude) AS min_longitude,
    MAX(longitude) AS max_longitude
FROM stations;

SELECT
    COUNT(*) AS suspicious_coordinates
FROM stations
WHERE latitude IS NULL
   OR longitude IS NULL
   OR latitude = 0
   OR longitude = 0;


/* ============================================================
   16. STATION COORDINATE CORRECTION
   ============================================================ */

UPDATE stations
SET
    latitude = 28.67823,
    longitude = 77.37065
WHERE station_name = 'Shyam Park';


/* ============================================================
   17. TICKET TYPE ANALYSIS
   ============================================================ */

SELECT
    ticket_type,
    COUNT(*) AS count_rows
FROM trips
WHERE ticket_type IS NOT NULL
  AND TRIM(ticket_type) <> ''
GROUP BY ticket_type
ORDER BY count_rows DESC;


/* ============================================================
   18. ORIGIN & DESTINATION DATA VALIDATION
   ============================================================ */

SELECT
    SUM(from_station IS NULL OR TRIM(from_station) = '')
        AS missing_from_station,
    SUM(to_station IS NULL OR TRIM(to_station) = '')
        AS missing_to_station
FROM trips;


/* ============================================================
   19. DISTANCE, FARE & COST VALIDATION
   ============================================================ */

SELECT
    MIN(distance_km) AS minimum_distance,
    MAX(distance_km) AS maximum_distance,
    AVG(distance_km) AS average_distance
FROM trips
WHERE distance_km IS NOT NULL;

SELECT
    COUNT(*) AS invalid_distance_rows
FROM trips
WHERE distance_km <= 0;


SELECT
    MIN(fare) AS minimum_fare,
    MAX(fare) AS maximum_fare,
    AVG(fare) AS average_fare
FROM trips
WHERE fare IS NOT NULL;

SELECT
    COUNT(*) AS invalid_fare_rows
FROM trips
WHERE fare <= 0;


SELECT
    MIN(cost_per_passenger) AS minimum_cost,
    MAX(cost_per_passenger) AS maximum_cost,
    AVG(cost_per_passenger) AS average_cost
FROM trips
WHERE cost_per_passenger IS NOT NULL;

SELECT
    COUNT(*) AS invalid_cost_rows
FROM trips
WHERE cost_per_passenger <= 0;


/* ============================================================
   20. TRIP DATE VALIDATION
   ============================================================ */

SELECT
    MIN(trip_date) AS earliest_trip,
    MAX(trip_date) AS latest_trip,
    COUNT(DISTINCT trip_date) AS unique_dates
FROM trips;


/* ============================================================
   21. REMARKS CLEANING
   ============================================================ */

SELECT
    remarks,
    COUNT(*) AS count_rows
FROM trips
WHERE remarks IS NOT NULL
  AND TRIM(remarks) <> ''
GROUP BY remarks
ORDER BY count_rows DESC;


UPDATE trips
SET remarks = TRIM(REPLACE(remarks, CHAR(13), ''));


SELECT
    remarks,
    COUNT(*) AS count_rows
FROM trips
GROUP BY remarks
ORDER BY count_rows DESC;


/* ============================================================
   22. OVERALL PROJECT KPIs
   ============================================================ */

SELECT
    COUNT(trip_id) AS total_trips,
    SUM(passenger) AS total_passengers,
    ROUND(AVG(passenger), 2) AS avg_passengers,
    ROUND(AVG(distance_km), 2) AS avg_distance,
    ROUND(AVG(fare), 2) AS avg_fare,
    ROUND(SUM(fare * passenger), 2) AS total_revenue
FROM trips;


/* ============================================================
   23. TICKET TYPE BUSINESS ANALYSIS
   ============================================================ */

SELECT
    ticket_type,
    COUNT(trip_id) AS total_trips_per_tickettype
FROM trips
WHERE ticket_type IS NOT NULL
  AND ticket_type <> ''
GROUP BY ticket_type;


SELECT
    ticket_type,
    SUM(passenger) AS total_passengers_per_tickettype
FROM trips
WHERE ticket_type IS NOT NULL
  AND ticket_type <> ''
GROUP BY ticket_type;


SELECT
    ticket_type,
    ROUND(AVG(fare), 2) AS avg_fare_per_tickettype
FROM trips
WHERE ticket_type IS NOT NULL
  AND ticket_type <> ''
GROUP BY ticket_type;


SELECT
    ticket_type,
    ROUND(SUM(fare * passenger), 2) AS total_revenue_per_tickettype
FROM trips
WHERE ticket_type IS NOT NULL
  AND ticket_type <> ''
GROUP BY ticket_type
ORDER BY total_revenue_per_tickettype DESC
LIMIT 1;


SELECT
    ticket_type,
    COUNT(trip_id) AS total_trips,
    ROUND(
        COUNT(trip_id) * 100.0 /
        (
            SELECT COUNT(trip_id)
            FROM trips
            WHERE ticket_type IS NOT NULL
              AND ticket_type <> ''
        ),
        2
    ) AS percentage_of_trips
FROM trips
WHERE ticket_type IS NOT NULL
  AND ticket_type <> ''
GROUP BY ticket_type;


/* ============================================================
   24. TOP ORIGINATING & DESTINATION STATIONS
   ============================================================ */

SELECT
    from_station,
    COUNT(trip_id) AS total_trips_per_source_station
FROM trips
GROUP BY from_station
ORDER BY total_trips_per_source_station DESC
LIMIT 10;


SELECT
    to_station,
    COUNT(trip_id) AS total_trips_per_destination_station
FROM trips
GROUP BY to_station
ORDER BY total_trips_per_destination_station DESC
LIMIT 10;


/* ============================================================
   25. MOST FREQUENTLY OCCURRING STATION
   ============================================================ */

SELECT
    station,
    COUNT(*) AS total_occurrences
FROM (
    SELECT from_station AS station
    FROM trips

    UNION ALL

    SELECT to_station AS station
    FROM trips
) AS all_stations
GROUP BY station
ORDER BY total_occurrences DESC
LIMIT 1;


/* ============================================================
   26. TOP ROUTES BY NUMBER OF TRIPS
   ============================================================ */

SELECT
    from_station,
    to_station,
    COUNT(trip_id) AS total_trips
FROM trips
GROUP BY from_station, to_station
ORDER BY total_trips DESC
LIMIT 10;


/* ============================================================
   27. TOP ROUTES BY PASSENGER VOLUME
   ============================================================ */

SELECT
    from_station,
    to_station,
    SUM(passenger) AS total_passenger
FROM trips
GROUP BY from_station, to_station
ORDER BY total_passenger DESC
LIMIT 10;


/* ============================================================
   28. FARE ANALYSIS
   ============================================================ */

SELECT
    MIN(fare) AS min_trip_fare,
    MAX(fare) AS max_trip_fare,
    ROUND(AVG(fare), 2) AS avg_trip_fare
FROM trips;


SELECT
    trip_id,
    from_station,
    to_station,
    fare
FROM trips
ORDER BY fare DESC
LIMIT 10;


/* ============================================================
   29. DISTANCE RANGE ANALYSIS
   ============================================================ */

SELECT
    CASE
        WHEN distance_km < 5 THEN '0-5 km'
        WHEN distance_km < 10 THEN '5-10 km'
        WHEN distance_km < 15 THEN '10-15 km'
        WHEN distance_km < 20 THEN '15-20 km'
        ELSE '20+ km'
    END AS distance_range,
    COUNT(*) AS total_trips,
    ROUND(AVG(fare), 2) AS average_fare
FROM trips
WHERE distance_km IS NOT NULL
  AND fare IS NOT NULL
GROUP BY distance_range
ORDER BY average_fare;


/* ============================================================
   30. SHORT, MEDIUM & LONG DISTANCE ANALYSIS
   ============================================================ */

SELECT
    CASE
        WHEN distance_km < 5 THEN 'Short'
        WHEN distance_km >= 5 AND distance_km <= 15 THEN 'Medium'
        ELSE 'Long'
    END AS distance_categories,
    COUNT(trip_id) AS total_trips,
    SUM(passenger) AS total_passengers
FROM trips
WHERE distance_km IS NOT NULL
  AND passenger IS NOT NULL
GROUP BY distance_categories;


/* ============================================================
   31. YEARLY PASSENGER ANALYSIS
   ============================================================ */

SELECT
    YEAR(trip_date) AS trip_year,
    SUM(passenger) AS passenger_volume
FROM trips
WHERE passenger IS NOT NULL
  AND trip_date IS NOT NULL
GROUP BY trip_year
ORDER BY trip_year;


/* ============================================================
   32. HIGHEST & LOWEST PASSENGER MONTH
   ============================================================ */

SELECT
    MONTHNAME(trip_date) AS trip_month,
    SUM(passenger) AS passenger_volume
FROM trips
WHERE passenger IS NOT NULL
  AND trip_date IS NOT NULL
GROUP BY trip_month
ORDER BY passenger_volume DESC
LIMIT 1;


SELECT
    MONTHNAME(trip_date) AS trip_month,
    SUM(passenger) AS passenger_volume
FROM trips
WHERE passenger IS NOT NULL
  AND trip_date IS NOT NULL
GROUP BY trip_month
ORDER BY passenger_volume ASC
LIMIT 1;


/* ============================================================
   33. TOP 10 DAYS BY PASSENGER VOLUME
   ============================================================ */

SELECT
    trip_date,
    SUM(passenger) AS passenger_volume
FROM trips
WHERE passenger IS NOT NULL
  AND trip_date IS NOT NULL
GROUP BY trip_date
ORDER BY passenger_volume DESC
LIMIT 10;


/* ============================================================
   34. AVERAGE DAILY PASSENGER VOLUME
   ============================================================ */

SELECT
    ROUND(AVG(daily_passengers), 2) AS avg_daily_passenger_volume
FROM (
    SELECT
        trip_date,
        SUM(passenger) AS daily_passengers
    FROM trips
    WHERE passenger IS NOT NULL
      AND trip_date IS NOT NULL
    GROUP BY trip_date
) AS daily_data;


/* ============================================================
   35. REMARKS / TRIP CATEGORY ANALYSIS
   ============================================================ */

SELECT
    remarks,
    COUNT(*) AS total_trips
FROM trips
WHERE remarks IS NOT NULL
  AND TRIM(remarks) <> ''
GROUP BY remarks
ORDER BY total_trips DESC;


SELECT
    remarks,
    SUM(passenger) AS total_passenger
FROM trips
WHERE remarks IS NOT NULL
  AND TRIM(remarks) <> ''
GROUP BY remarks
ORDER BY total_passenger DESC;


SELECT
    remarks,
    COUNT(trip_id) AS total_trips
FROM trips
WHERE remarks = 'maintenance';


SELECT
    remarks,
    ROUND(AVG(fare), 2) AS avg_fare,
    SUM(passenger) AS total_passenger
FROM trips
WHERE remarks IS NOT NULL
  AND TRIM(remarks) <> ''
GROUP BY remarks
ORDER BY avg_fare DESC, total_passenger DESC;


/* ============================================================
   36. ABOVE-AVERAGE ORIGINATING STATIONS
   ============================================================ */

SELECT
    from_station,
    originating_trips
FROM (
    SELECT
        from_station,
        COUNT(*) AS originating_trips
    FROM trips
    GROUP BY from_station
) AS station_trips
WHERE originating_trips > (
    SELECT AVG(originating_trips)
    FROM (
        SELECT
            from_station,
            COUNT(*) AS originating_trips
        FROM trips
        GROUP BY from_station
    ) AS avg_trips
)
ORDER BY originating_trips DESC;


/* ============================================================
   37. TOP 5 ROUTES BY YEAR
   CTE + DENSE_RANK() WINDOW FUNCTION
   ============================================================ */

WITH route_data AS (
    SELECT
        from_station,
        to_station,
        YEAR(trip_date) AS trip_year,
        SUM(passenger) AS total_passengers
    FROM trips
    WHERE passenger IS NOT NULL
      AND trip_date IS NOT NULL
    GROUP BY
        from_station,
        to_station,
        YEAR(trip_date)
),
ranked_routes AS (
    SELECT
        from_station,
        to_station,
        trip_year,
        total_passengers,
        DENSE_RANK() OVER (
            PARTITION BY trip_year
            ORDER BY total_passengers DESC
        ) AS route_rank
    FROM route_data
)
SELECT
    trip_year,
    from_station,
    to_station,
    total_passengers,
    route_rank
FROM ranked_routes
WHERE route_rank <= 5
ORDER BY trip_year, route_rank;


/* ============================================================
   38. STATION PASSENGER VOLUME & RANKING
   CTE + UNION ALL + DENSE_RANK() WINDOW FUNCTION
   ============================================================ */

WITH station_volume AS (
    SELECT
        from_station AS station,
        SUM(passenger) AS passenger_volume
    FROM trips
    WHERE passenger IS NOT NULL
    GROUP BY from_station

    UNION ALL

    SELECT
        to_station AS station,
        SUM(passenger) AS passenger_volume
    FROM trips
    WHERE passenger IS NOT NULL
    GROUP BY to_station
),
combined_volume AS (
    SELECT
        station,
        SUM(passenger_volume) AS total_passenger_volume
    FROM station_volume
    GROUP BY station
),
ranked_stations AS (
    SELECT
        station,
        total_passenger_volume,
        DENSE_RANK() OVER (
            ORDER BY total_passenger_volume DESC
        ) AS station_rank
    FROM combined_volume
)
SELECT
    station,
    total_passenger_volume,
    station_rank
FROM ranked_stations
ORDER BY station_rank;


/* ============================================================
   END OF DELHI METRO SQL PROJECT
   ============================================================ */
```
