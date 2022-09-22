USE nyc_taxi_ldw

--To transform all file type to Parquet format
-- 3) payment_type (from JSON[Bronze] to Parquet[Silver])

IF OBJECT_ID(silver.payment_type) IS NOT NULL
    DROP EXTERNAL TABLE silver.payment_type

CREATE EXTERNAL TABLE silver.payment_type
    WITH(
        DATA_SOURCE = nyc_taxi_src, 
        LOCATION = 'silver/payment_type',
        FILE_FORMAT = parquet_file_format
    )
AS 
SELECT * FROM bronze.vw_payment_type; -- use from VIEW

-- Query 
SELECT * FROM silver.payment_type