CREATE SCHEMA staging
GO

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'parquet_file_format') 
	CREATE EXTERNAL FILE FORMAT parquet_file_format
	WITH ( FORMAT_TYPE = PARQUET)
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'nyc_taxi_data_src') 
	CREATE EXTERNAL DATA SOURCE nyc_taxi_data_src
	WITH (
		LOCATION = 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE staging.ext_trip_data_green_agg (
	[pu_location_id] int,
	[do_location_id] int,
	[total_trip_count] bigint,
	[total_fare_amount] float
	)
	WITH (
	LOCATION = 'gold/trip_data_green_agg',
	DATA_SOURCE = nyc_taxi_data_src,
	FILE_FORMAT = parquet_file_format
	)
GO

SELECT TOP 100 * FROM staging.ext_trip_data_green_agg
GO


-- use CTAS statement to insert data from External table to Physical TABLE 

-- https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-as-select-azure-sql-data-warehouse?toc=%2Fazure%2Fsynapse-analytics%2Fsql-data-warehouse%2Ftoc.json&bc=%2Fazure%2Fsynapse-analytics%2Fsql-data-warehouse%2Fbreadcrumb%2Ftoc.json&view=azure-sqldw-latest&preserve-view=true

-- Create SCHEMA 
CREATE SCHEMA dwh 
GO

-- Create TABLE
CREATE TABLE dwh.trip_data_green_agg  
WITH   
  (   
    CLUSTERED COLUMNSTORE INDEX,  
    DISTRIBUTION = ROUND_ROBIN  
  )  
AS SELECT * FROM staging.ext_trip_data_green_agg; 
GO









