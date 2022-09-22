USE nyc_taxi_ldw

/*
--To transform all file type to Parquet format
-- 3) trip_data (from CSV partitioned[Bronze] to Parquet[Silver])

IF OBJECT_ID(silver.trip_data_green) IS NOT NULL
    DROP EXTERNAL TABLE silver.trip_data_green

CREATE EXTERNAL TABLE silver.trip_data_green
    WITH(
        DATA_SOURCE = nyc_taxi_src, 
        LOCATION = 'silver/trip_data_green',
        FILE_FORMAT = parquet_file_format
    )
AS 
SELECT * FROM bronze.trip_data_green_csv; 
-- Query 
SELECT TOP(100) * FROM silver.trip_data_green


-- Separate each folder by year and month
CREATE EXTERNAL TABLE silver.trip_data_green_2020_01
   WITH(
        DATA_SOURCE = nyc_taxi_src, 
        LOCATION = 'silver/trip_data_green/year=2020/month=01',
        FILE_FORMAT = parquet_file_format
    )
AS 
SELECT * 
    FROM bronze.vw.trip_data_green_csv
    WHERE year = '2020'
     AND MONTH = '01'

*/

EXEC silver.usp_silver_trip_data_green '2020', '01';
EXEC silver.usp_silver_trip_data_green '2020', '02';
EXEC silver.usp_silver_trip_data_green '2020', '03';
EXEC silver.usp_silver_trip_data_green '2020', '04';
EXEC silver.usp_silver_trip_data_green '2020', '05';
EXEC silver.usp_silver_trip_data_green '2020', '06';
EXEC silver.usp_silver_trip_data_green '2020', '07';
EXEC silver.usp_silver_trip_data_green '2020', '08';
EXEC silver.usp_silver_trip_data_green '2020', '09';
EXEC silver.usp_silver_trip_data_green '2020', '10';
EXEC silver.usp_silver_trip_data_green '2020', '11';
EXEC silver.usp_silver_trip_data_green '2020', '12';
EXEC silver.usp_silver_trip_data_green '2021', '01';
EXEC silver.usp_silver_trip_data_green '2021', '02';
EXEC silver.usp_silver_trip_data_green '2021', '03';
EXEC silver.usp_silver_trip_data_green '2021', '04';
EXEC silver.usp_silver_trip_data_green '2021', '05';
EXEC silver.usp_silver_trip_data_green '2021', '06';











