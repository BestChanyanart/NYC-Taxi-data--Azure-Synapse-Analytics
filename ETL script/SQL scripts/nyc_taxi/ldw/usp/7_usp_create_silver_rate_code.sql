USE nyc_taxi_ldw


CREATE OR ALTER PROCEDURE silver.usp_silver_rate_code
AS
BEGIN
    IF OBJECT_ID('silver.rate_code') IS NOT NULL    
        DROP EXTERNAL TABLE silver.rate_code;

    CREATE EXTERNAL TABLE silver.rate_code
        WITH
        (
            DATA_SOURCE = nyc_taxi_src, 
            LOCATION = 'silver/rate_code',  --create new folder Silver and rate_code folder
            FILE_FORMAT = parquet_file_format 
        )
    AS 
    SELECT * FROM bronze.vw_rate_code;
END; 

-- Query 
SELECT * FROM silver.rate_code
