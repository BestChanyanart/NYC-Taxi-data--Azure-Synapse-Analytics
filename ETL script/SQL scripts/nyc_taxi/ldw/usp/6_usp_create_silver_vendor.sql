USE nyc_taxi_ldw


CREATE OR ALTER PROCEDURE silver.usp_silver_vendor
AS
BEGIN
    IF OBJECT_ID('silver.vendor') IS NOT NULL    
        DROP EXTERNAL TABLE silver.vendor;

    CREATE EXTERNAL TABLE silver.vendor
        WITH
        (
            DATA_SOURCE = nyc_taxi_src, 
            LOCATION = 'silver/vendor',  --create new folder Silver and vendor folder
            FILE_FORMAT = parquet_file_format 
        )
    AS 
    SELECT * FROM bronze.vendor;
END; 

-- Query 
SELECT * FROM silver.vendor
