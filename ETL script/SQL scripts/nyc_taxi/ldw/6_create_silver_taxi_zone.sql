USE nyc_taxi_ldw

-- CETAS 
-- To transform all file type to Parquet format
-- 1) Taxi_zone (from CSV[Bronze] to Parquet[Silver])
IF OBJECT_ID('silver.taxi_zone') IS NOT NULL    
    DROP EXTERNAL TABLE silver.taxi_zone
GO 

CREATE EXTERNAL TABLE silver.taxi_zone
    WITH
    (
        DATA_SOURCE = nyc_taxi_src, 
        LOCATION = 'silver/taxi_zone',  --create new folder Silver and Taxi_zone folder
        FILE_FORMAT = parquet_file_format 
    )
AS 
SELECT * FROM bronze.taxi_zone;

-- Query 
SELECT * FROM silver.taxi_zone
