CREATE DATABASE Delhi_Metro_Project;
CREATE TABLE stations (
stations_id INT,
station_name varchar(100),
distance_from_first_station DECIMAL(10,2),
metro_line VARCHAR(100),
opened_year VARCHAR(20),
layout VARCHAR(50),
latitude DECIMAL(10,7),
longitude DECIMAL(10,7));
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
SELECT COUNT(*) FROM stations; 
SELECT COUNT(*) FROM trips;
SHOW TABLES;
SET GLOBAL local_infile=1;
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT @@global.secure_file_priv;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/delhi_metro_trips.csv'
INTO TABLE trips
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trip_id, @trip_date, from_station, to_station, distance_km, fare,
 cost_per_passenger, @passenger, ticket_type, remarks)
SET
trip_date = STR_TO_DATE(@trip_date, '%d-%m-%Y'),
passenger = NULLIF(@passenger, '');
DESCRIBE trips;
SELECT
    COUNT(*) AS total_rows,
    SUM(trip_id IS NULL) AS missing_trip_id,
    SUM(trip_date IS NULL) AS missing_date,
    SUM(from_station IS NULL OR TRIM(from_station) = '') AS missing_from_station,
    SUM(to_station IS NULL OR TRIM(to_station) = '') AS missing_to_station,
    SUM(distance_km IS NULL) AS missing_distance,
    SUM(fare IS NULL) AS missing_fare,
    SUM(cost_per_passenger IS NULL) AS missing_cost,
    SUM(passenger IS NULL OR TRIM(passenger) = '') AS missing_passenger,
    SUM(ticket_type IS NULL OR TRIM(ticket_type) = '') AS missing_ticket_type,
    SUM(remarks IS NULL OR TRIM(remarks) = '') AS missing_remarks
FROM trips;
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
WHERE passenger IS NULL OR TRIM(passenger) = ''
   OR ticket_type IS NULL OR TRIM(ticket_type) = ''
GROUP BY passenger, ticket_type
ORDER BY count_rows DESC;
SELECT trip_id, COUNT(*) AS count_rows
FROM trips
GROUP BY trip_id
HAVING COUNT(*)>1;
SELECT passenger, COUNT(*) AS count_rows
FROM trips
WHERE passenger IS NOT NULL
AND TRIM(passenger)<>''
GROUP BY passenger
ORDER BY CAST(passenger AS unsigned);
SELECT
    MIN(CAST(passenger AS UNSIGNED)) AS minimum_passenger,
    MAX(CAST(passenger AS UNSIGNED)) AS maximum_passenger,
    COUNT(DISTINCT passenger) AS unique_passengers
FROM trips
WHERE passenger IS NOT NULL
  AND TRIM(passenger) <> '';
SELECT * FROM stations LIMIT 5;
SELECT
    SUM(stations_id IS NULL OR TRIM(stations_id) = '') AS missing_station_id,
    SUM(station_name IS NULL OR TRIM(station_name) = '') AS missing_station_name,
    SUM(distance_from_first_station IS NULL) AS missing_distance,
    SUM(metro_line IS NULL OR TRIM(metro_line) = '') AS missing_metro_line,
    SUM(opened_year IS NULL) AS missing_opened_year,
    SUM(layout IS NULL OR TRIM(layout) = '') AS missing_layout,
    SUM(latitude IS NULL) AS missing_latitude,
    SUM(longitude IS NULL) AS missing_longitude
FROM stations;
SELECT
    station_name,
    COUNT(*) AS count_rows
FROM stations
GROUP BY station_name
HAVING COUNT(*) > 1
ORDER BY count_rows DESC;
SELECT * FROM stations
WHERE station_name in('Yamuna Bank','Ashok Park Main');
SELECT
    stations_id,
    COUNT(*) AS count_rows
FROM stations
GROUP BY stations_id
HAVING COUNT(*) > 1;
SELECT
    stations_id,
    COUNT(*) AS count_rows,
    COUNT(DISTINCT station_name) AS unique_station_names
FROM stations
GROUP BY stations_id
ORDER BY stations_id;
SELECT
    stations_id,
    station_name,
    metro_line
FROM stations
ORDER BY stations_id
LIMIT 30;
SELECT
    COUNT(*) AS total_station_rows,
    COUNT(DISTINCT station_name) AS unique_station_names,
    COUNT(DISTINCT stations_id) AS unique_station_ids
FROM stations;
SET SQL_SAFE_UPDATES=0;
UPDATE stations
SET station_name = TRIM(station_name)
WHERE LENGTH(station_name) > LENGTH(TRIM(station_name));
SELECT
    CONCAT('[', station_name, ']') AS station_name,
    LENGTH(station_name) AS length_value,
    LENGTH(TRIM(station_name)) AS trimmed_length
FROM stations
WHERE LENGTH(station_name) > LENGTH(TRIM(station_name));
SELECT metro_line,COUNT(*) AS count_rows
FROM stations
GROUP BY metro_line
ORDER BY count_rows DESC;
SELECT
    CONCAT('[', metro_line, ']') AS metro_line,
    LENGTH(metro_line) AS length_value,
    LENGTH(TRIM(metro_line)) AS trimmed_length
FROM stations
WHERE LENGTH(metro_line) <> LENGTH(TRIM(metro_line));
select opened_year,COUNT(*) AS count_rows 
FROM stations
group by opened_year
ORDER BY opened_year
LIMIT 10;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT opened_year) AS unique_opening_dates
FROM stations;
SELECT opened_year
FROM stations
WHERE opened_year NOT REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';
SELECT
    layout,
    COUNT(*) AS count_rows
FROM stations
GROUP BY layout
ORDER BY count_rows DESC;
SELECT
    MIN(latitude) AS min_latitude,
    MAX(latitude) AS max_latitude,
    MIN(longitude) AS min_longitude,
    MAX(longitude) AS max_longitude
FROM stations;
SELECT
    station_name,
    latitude,
    longitude
FROM stations
WHERE longitude < 70;
SELECT
    station_name,
    latitude,
    longitude
FROM stations
WHERE station_name LIKE '%Shyam%'
   OR station_name LIKE '%Mohan%';
SELECT
    station_name,
    latitude,
    longitude,
    metro_line
FROM stations
WHERE metro_line = 'Red line'
ORDER BY latitude;
UPDATE stations
SET
    latitude = 28.67823,
    longitude = 77.37065
WHERE station_name = 'Shyam Park';
SELECT
    station_name,
    latitude,
    longitude
FROM stations
WHERE station_name = 'Shyam Park';
SELECT
    COUNT(*) AS suspicious_coordinates
FROM stations
WHERE latitude IS NULL
   OR longitude IS NULL
   OR latitude = 0
   OR longitude = 0;
SELECT
    opened_year
FROM stations
WHERE STR_TO_DATE(opened_year, '%d-%m-%Y') IS NULL;
SELECT
    ticket_type,
    COUNT(*) AS count_rows
FROM trips
WHERE ticket_type IS NOT NULL
  AND TRIM(ticket_type) <> ''
GROUP BY ticket_type
ORDER BY count_rows DESC;
SELECT
    CONCAT('[', ticket_type, ']') AS ticket_type,
    LENGTH(ticket_type) AS length_value,
    LENGTH(TRIM(ticket_type)) AS trimmed_length
FROM trips
WHERE ticket_type IS NOT NULL
  AND TRIM(ticket_type) <> ''
  AND LENGTH(ticket_type) <> LENGTH(TRIM(ticket_type));
SELECT * FROM trips
  limit 1;
SELECT
    SUM(`from_station` IS NULL OR TRIM(`from_station`) = '') AS missing_from_station,
    SUM(`to_station` IS NULL OR TRIM(`to_station`) = '') AS missing_to_station
FROM trips;
SELECT DISTINCT t.`from_station`
FROM trips t
LEFT JOIN stations s
    ON TRIM(t.`from_station`) = TRIM(s.station_name)
WHERE s.station_name IS NULL
  AND t.`from_station` IS NOT NULL;
SELECT COUNT(*) AS rows_with_spaces
FROM trips
WHERE LENGTH(`from_station`) <> LENGTH(TRIM(`from_station`));
SELECT COUNT(DISTINCT t.`from_station`) AS unmatched_after_trim
FROM trips t
LEFT JOIN stations s
    ON TRIM(t.`from_station`) = TRIM(s.station_name)
WHERE s.station_name IS NULL
  AND t.`from_station` IS NOT NULL
  AND TRIM(t.`from_station`) <> '';
  SELECT DISTINCT
    t.`from_station`
FROM trips t
LEFT JOIN stations s
    ON TRIM(t.`from_station`) = TRIM(s.station_name)
WHERE s.station_name IS NULL
  AND t.`from_station` IS NOT NULL
  AND TRIM(t.`from_station`) <> ''
LIMIT 20;
SELECT COUNT(DISTINCT t.`from_station`) AS unmatched_after_cleaning
FROM trips t
LEFT JOIN stations s
    ON LOWER(
         TRIM(REPLACE(t.`from_station`, CHAR(160), ' '))
       ) = LOWER(
         TRIM(REPLACE(s.station_name, CHAR(160), ' '))
       )
WHERE s.station_name IS NULL
  AND t.`from_station` IS NOT NULL
  AND TRIM(REPLACE(t.`from_station`, CHAR(160), ' ')) <> '';
 SELECT COUNT(DISTINCT t.from_station) AS unmatched
FROM trips t
LEFT JOIN stations s
    ON LOWER(TRIM(t.from_station)) = LOWER(TRIM(s.station_name))
WHERE s.station_name IS NULL
  AND t.from_station IS NOT NULL
  AND TRIM(t.from_station) <> '';
  SELECT DISTINCT
    CONCAT('[', from_station, ']') AS trip_station
FROM trips t
LEFT JOIN stations s
    ON LOWER(TRIM(t.from_station)) = LOWER(TRIM(s.station_name))
WHERE s.station_name IS NULL
  AND t.from_station IS NOT NULL
  AND TRIM(t.from_station) <> ''
LIMIT 20;
SELECT DISTINCT
    CONCAT('[', from_station, ']') AS original,
    CONCAT('[', TRIM(REGEXP_REPLACE(from_station, '[[:space:]]+', ' ')), ']') AS cleaned
FROM trips t
LEFT JOIN stations s
    ON LOWER(TRIM(REGEXP_REPLACE(t.from_station, '[[:space:]]+', ' ')))
     = LOWER(TRIM(REGEXP_REPLACE(s.station_name, '[[:space:]]+', ' ')))
WHERE s.station_name IS NULL
  AND t.from_station IS NOT NULL
LIMIT 20;
SELECT
    station_name
FROM stations
WHERE LOWER(TRIM(REGEXP_REPLACE(station_name, '[[:space:]]+', ' '))) = 'inderlok';
SELECT
    station_name,
    metro_line
FROM stations
WHERE station_name LIKE '%Inder%';
SELECT DISTINCT
    t.from_station AS trip_station,
    s.station_name AS station_table_name
FROM trips t
JOIN stations s
    ON LOWER(TRIM(REGEXP_REPLACE(s.station_name, '[[:space:]]+', ' ')))
       LIKE CONCAT('%', LOWER(TRIM(REGEXP_REPLACE(t.from_station, '[[:space:]]+', ' '))), '%')
WHERE t.from_station IS NOT NULL
LIMIT 30;
SELECT COUNT(DISTINCT t.to_station) AS unmatched_to_stations
FROM trips t
LEFT JOIN stations s
    ON LOWER(TRIM(REGEXP_REPLACE(t.to_station, '[[:space:]]+', ' ')))
     = LOWER(TRIM(REGEXP_REPLACE(s.station_name, '[[:space:]]+', ' ')))
WHERE s.station_name IS NULL
  AND t.to_station IS NOT NULL
  AND TRIM(t.to_station) <> '';
  SELECT DISTINCT
    t.to_station AS trip_station,
    s.station_name AS possible_match
FROM trips t
JOIN stations s
    ON LOWER(TRIM(REGEXP_REPLACE(s.station_name, '[[:space:]]+', ' ')))
       LIKE CONCAT('%', LOWER(TRIM(REGEXP_REPLACE(t.to_station, '[[:space:]]+', ' '))), '%')
WHERE t.to_station IS NOT NULL
LIMIT 30;
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
SELECT COUNT(*) AS invalid_fare_rows
FROM trips
WHERE fare <= 0;
SELECT
    MIN(cost_per_passenger) AS minimum_cost,
    MAX(cost_per_passenger) AS maximum_cost,
    AVG(cost_per_passenger) AS average_cost
FROM trips
WHERE cost_per_passenger IS NOT NULL;
SELECT COUNT(*) AS invalid_cost_rows
FROM trips
WHERE cost_per_passenger <= 0;
SELECT
    MIN(trip_date) AS earliest_trip,
    MAX(trip_date) AS latest_trip,
    COUNT(DISTINCT trip_date) AS unique_dates
FROM trips;
SELECT
    remarks,
    COUNT(*) AS count_rows
FROM trips
WHERE remarks IS NOT NULL
  AND TRIM(remarks) <> ''
GROUP BY remarks
ORDER BY count_rows DESC;
SELECT
    COUNT(*) AS rows_with_carriage_return
FROM trips
WHERE remarks LIKE CONCAT('%', CHAR(13), '%');
UPDATE trips
SET remarks = TRIM(REPLACE(remarks, CHAR(13), ''));
SELECT
    remarks,
    COUNT(*) AS count_rows
FROM trips
GROUP BY remarks
ORDER BY count_rows DESC;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT trip_id) AS unique_trip_ids
FROM trips;
SELECT COUNT(trip_id) AS total_trips,
SUM(passenger) as total_passengers,
ROUND(AVG(passenger),2) as avg_passengers,
ROUND(AVG(distance_km),2) as avg_distance,
ROUND(AVG(fare),2) as avg_fare,
ROUND(SUM(fare*passenger),2) as total_revenue
FROM trips;
SELECT ticket_type,COUNT(trip_id) as total_trips_per_tickettype
from trips
WHERE ticket_type is not null and ticket_type<>''
group by ticket_type;
SELECT ticket_type,SUM(passenger) as total_passengers_per_tickettype
from trips
WHERE ticket_type is not null and ticket_type<>''
group by ticket_type;
SELECT ticket_type,ROUND(AVG(fare),2) as avg_fare_per_tickettype
from trips
WHERE ticket_type is not null and ticket_type<>''
group by ticket_type;
SELECT ticket_type,ROUND(SUM(fare*passenger),2) as total_revenue_per_tickettype
from trips
WHERE ticket_type is not null and ticket_type<>''
group by ticket_type
order by total_revenue_per_tickettype DESC
limit 1;
SELECT
    ticket_type,
    COUNT(trip_id) AS total_trips,
    ROUND(
        COUNT(trip_id) * 100.0 /
        (SELECT COUNT(trip_id) from trips where ticket_type is not null and ticket_type<>''),2) AS percentage_of_trips
FROM trips
WHERE ticket_type is not null and ticket_type<>''
GROUP BY ticket_type;
SELECT from_station,COUNT(trip_id) as totaltrips_per_sourcestation
from trips
group by from_station
order by totaltrips_per_sourcestation DESC
LIMIT 10;
SELECT to_station,COUNT(trip_id) as totaltrips_per_destinationstation
from trips
group by to_station
order by totaltrips_per_destinationstation DESC
LIMIT 10;
SELECT station, COUNT(*) AS total_occurrences
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
SELECT 
    from_station,
    to_station,
    COUNT(trip_id) AS total_trips
FROM trips
GROUP BY from_station,to_station
ORDER BY total_trips DESC
LIMIT 10;
SELECT 
    from_station,
    to_station,
    SUM(passenger) AS total_passenger
FROM trips
GROUP BY from_station,to_station
ORDER BY total_passenger DESC
LIMIT 10;
SELECT MIN(fare) as min_trip_fare,MAX(fare) as max_trip_fare,ROUND(AVG(fare),2) as avg_trip_fare
from trips;
SELECT trip_id,from_station,to_station,fare
from trips
order by fare DESC
LIMIT 10;
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
WHERE distance_km IS NOT NULL AND fare IS NOT NULL
GROUP BY distance_range
ORDER BY average_fare;
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
SET SQL_SAFE_UPDATES=0;
SELECT trip_date
FROM trips;
SELECT YEAR(trip_date) as trip_year,SUM(passenger) as passenger_volume
from trips
where passenger is not null and trip_date is not null
group by trip_year
ORDER BY trip_year;
SELECT monthname(trip_date) as trip_month,SUM(passenger) as passenger_volume
from trips
where passenger is not null and trip_date is not null
group by trip_month
ORDER BY passenger_volume DESC
LIMIT 1;
SELECT monthname(trip_date) as trip_month,SUM(passenger) as passenger_volume
from trips
where passenger is not null and trip_date is not null
group by trip_month
ORDER BY passenger_volume ASC
LIMIT 1;
SELECT trip_date,SUM(passenger) as passenger_volume
from trips
where passenger is not null and trip_date is not null
group by trip_date
ORDER BY passenger_volume DESC
LIMIT 10;
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
SELECT remarks, COUNT(*) AS total_trips
FROM trips
WHERE remarks IS NOT NULL AND TRIM(remarks) <> ''
GROUP BY remarks
ORDER BY total_trips DESC;
SELECT remarks, SUM(passenger) AS total_passenger
FROM trips
WHERE remarks IS NOT NULL AND TRIM(remarks) <> ''
GROUP BY remarks
ORDER BY total_passenger DESC;
SELECT remarks,COUNT(trip_id)as total_trips
from trips 
where remarks='maintenance';
SELECT remarks, ROUND(AVG(fare),2) as avg_fare,SUM(passenger) as total_passenger
from trips
where remarks is not null and trim(remarks)<>''
group by remarks
order by avg_fare DESC,total_passenger DESC;
SELECT from_station,originating_trips
FROM (
    SELECT from_station,COUNT(*) AS originating_trips
    FROM trips
    GROUP BY from_station
) AS station_trips
WHERE originating_trips > (
    SELECT AVG(originating_trips)
    FROM (
        SELECT from_station,COUNT(*) AS originating_trips
        FROM trips
        GROUP BY from_station
    ) AS avg_trips
)
ORDER BY originating_trips DESC;
WITH route_data AS (
    SELECT
        from_station,
        to_station,
        YEAR(trip_date) AS trip_year,
        SUM(passenger) AS total_passengers
    FROM trips
    WHERE passenger IS NOT NULL
      AND trip_date IS NOT NULL
    GROUP BY from_station, to_station, YEAR(trip_date)
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