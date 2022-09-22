USE nyc_taxi_ldw

-- campaigns requirement 
-- Select Statement 

/*
SELECT  td.year, 
        td.month, 
        tz.borough,
        CONVERT(DATE, td.lpep_pickup_datetime) AS trip_date,
        cal.day_name AS trip_day,
        CASE WHEN cal.day_name IN ('Saturday', 'Sunday') THEN 'Y' ELSE 'N' END AS trip_day_weekend_ind,
        SUM(CASE WHEN pt.description = 'Credit card' THEN 1 ELSE 0 END) AS card_trip_count,
        SUM(CASE WHEN pt.description = 'Cash' THEN 1 ELSE 0 END) AS cash_trip_count
    FROM silver.vw_trip_data_green AS td
    JOIN silver.taxi_zone AS tz
        ON (td.pu_location_id = tz.location_id)
    JOIN silver.calendar AS cal
        ON (cal.date = CONVERT(DATE, td.lpep_pickup_datetime))
    JOIN silver.payment_type AS pt 
        ON(td.payment_type = pt.payment_type)
    WHERE td.year = '2020' 
        AND td.month = '01' 
    GROUP BY td.year, 
            td.month, 
            tz.borough,
            CONVERT(DATE, td.lpep_pickup_datetime),
            cal.day_name
*/

EXEC gold.usp_gold_trip_data_green '2020', '01';
EXEC gold.usp_gold_trip_data_green '2020', '02';
EXEC gold.usp_gold_trip_data_green '2020', '03';
EXEC gold.usp_gold_trip_data_green '2020', '04';
EXEC gold.usp_gold_trip_data_green '2020', '05';
EXEC gold.usp_gold_trip_data_green '2020', '06';
EXEC gold.usp_gold_trip_data_green '2020', '07';
EXEC gold.usp_gold_trip_data_green '2020', '08';
EXEC gold.usp_gold_trip_data_green '2020', '09';
EXEC gold.usp_gold_trip_data_green '2020', '10';
EXEC gold.usp_gold_trip_data_green '2020', '11';
EXEC gold.usp_gold_trip_data_green '2020', '12';
EXEC gold.usp_gold_trip_data_green '2021', '01';
EXEC gold.usp_gold_trip_data_green '2021', '02';
EXEC gold.usp_gold_trip_data_green '2021', '03';
EXEC gold.usp_gold_trip_data_green '2021', '04';
EXEC gold.usp_gold_trip_data_green '2021', '05';
EXEC gold.usp_gold_trip_data_green '2021', '06';
