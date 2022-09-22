USE nyc_taxi_ldw

--To transform all file type to Parquet format
-- 3) rate_code (from JSON[Bronze] to Parquet[Silver])

IF OBJECT_ID(silver.rate_code) IS NOT NULL
    DROP EXTERNAL TABLE silver.rate_code

CREATE EXTERNAL TABLE silver.rate_code
    WITH(
        DATA_SOURCE = nyc_taxi_src, 
        LOCATION = 'silver/rate_code',
        FILE_FORMAT = parquet_file_format
    )
AS 
SELECT * FROM bronze.vw_rate_code; -- use from VIEW

-- Query 
SELECT * FROM silver.rate_code