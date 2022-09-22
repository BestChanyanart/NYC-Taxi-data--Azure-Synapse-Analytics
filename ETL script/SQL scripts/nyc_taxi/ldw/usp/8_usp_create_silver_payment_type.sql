USE nyc_taxi_ldw


CREATE OR ALTER PROCEDURE silver.usp_silver_payment_type
AS
BEGIN
    IF OBJECT_ID('silver.payment_type') IS NOT NULL    
        DROP EXTERNAL TABLE silver.payment_type;

    CREATE EXTERNAL TABLE silver.payment_type
        WITH
        (
            DATA_SOURCE = nyc_taxi_src, 
            LOCATION = 'silver/payment_type',  --create new folder Silver and payment_type folder
            FILE_FORMAT = parquet_file_format 
        )
    AS 
    SELECT * FROM bronze.vw_payment_type;
END; 

-- Query 
SELECT * FROM silver.payment_type
