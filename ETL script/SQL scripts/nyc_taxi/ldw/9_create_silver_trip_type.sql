USE nyc_taxi_ldw

--To transform all file type to Parquet format
-- 3) Trip_type (from CSV[Bronze] to Parquet[Silver])

IF OBJECT_ID(silver.trip_type) IS NOT NULL
    DROP EXTERNAL TABLE silver.trip_type

CREATE EXTERNAL TABLE silver.trip_type
    WITH(
        DATA_SOURCE = nyc_taxi_src, 
        LOCATION = 'silver/trip_type',
        FILE_FORMAT = parquet_file_format
    )
AS 
SELECT * FROM bronze.trip_type;

-- Query 
SELECT * FROM silver.trip_type