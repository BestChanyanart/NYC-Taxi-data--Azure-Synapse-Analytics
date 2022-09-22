
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://<DATALAKENAME>.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0'
    ) AS [result]


SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS [result]

-- Examine the data types for the column
EXEC sp_describe_first_result_set N'SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ''abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw/taxi_zone.csv'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW = TRUE
    ) AS [result]'

-- To check MAX length of each columns
SELECT
    MAX(LEN(LocationID)) AS len_LocationID,
    MAX(LEN(Borough)) AS len_Borough,
    MAX(LEN(Zone)) AS len_Zone,
    MAX(LEN(service_zone)) AS len_service_zone
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS [result]

-- Use WITH clause to provide explicit data types (specify new data type)
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH (
        LocationID SMALLINT, 
        Borough VARCHAR(15), 
        Zone VARCHAR(50),
        service_zone VARCHAR(15)
    )AS [result]

-- Check the default of Collasion 
SELECT name, collation_name FROM sys.databases

--Specify UTF-8 Collation for VARCHAR column
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH (
        LocationID SMALLINT,       
        Borough VARCHAR(15) COLLATE Latin1_General_100_BIN2_UTF8, 
        Zone VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
        service_zone VARCHAR(15) COLLATE Latin1_General_100_BIN2_UTF8
    )AS [result]

-- Create New Databases and Apply Collation in Database-level
CREATE DATABASE nyc_taxi_discovery 
USE nyc_taxi_discovery

ALTER DATABASE nyc_taxi_discovery COLLATE Latin1_General_100_BIN2_UTF8;

SELECT name, collation_name FROM sys.databases

-- To check warning Does it show again? - No
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH (
        LocationID SMALLINT, 
        Borough VARCHAR(15), 
        Zone VARCHAR(50),
        service_zone VARCHAR(15)
    )AS [result]

-- Select only Subset of Column 
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH ( 
        Borough VARCHAR(15), 
        Zone VARCHAR(50)
    )AS [result]

-- Specify Index and Read data without HEADERROW, specify start FIRSTROW = 2
SELECT
    *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH ( 
        Zone VARCHAR(50) 3,
        Borough VARCHAR(15) 2
    )AS [result]


-- Create External Data Source
CREATE EXTERNAL DATA SOURCE nyc_taxi_raw
WITH(
    LOCATION = 'abfss://nyc-taxi-data@<DATALAKENAME>.dfs.core.windows.net/raw'   -- Container 
)

SELECT
    *
FROM
    OPENROWSET(
        BULK 'taxi_zone.csv',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH (
        LocationID SMALLINT 1, 
        Borough VARCHAR(15) 2, 
        Zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    )AS [result]

-- DROP DATA SOURCE
DROP EXTERNAL DATA SOURCE nyc_taxii

-- Find where each DATA SOURCE are? 
SELECT name, location FROM sys.external_data_sources;

