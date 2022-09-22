USE nyc_taxi_discovery

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/month=01/green_tripdata_2020-01.csv',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]

--Select data from folder 
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/month=01/*.csv',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]

--Select data from subfolders 
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/**', -- double star** to get the file from subfolder 
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]

--Get Data from Subfolder but need only Jan - Mar
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=2020/month=01/*', -- use bracket ()
        'trip_data_green_csv/year=2020/month=02/*',
        'trip_data_green_csv/year=2020/month=03/*'),
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]

--Use more than 1 wildcard character, get all year and get all month
SELECT   
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv', -- use more than 1 star *
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]

-- How to get 'File Name' along side with the record
-- File Metadata function filename()
SELECT   
    TOP 100 
    result.filename() AS file_name,
    result.*
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv', -- use more than 1 star *
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]

-- To check How many record in each file? - use group by and count
SELECT   
    result.filename() AS file_name,
    COUNT(1) AS record_counts
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv', 
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]
GROUP BY result.filename()
ORDER BY result.filename()

-- Limit data using filename() - use WHERE
SELECT   
    result.filename() AS file_name,
    COUNT(1) AS record_counts
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv', 
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]
WHERE result.filename() IN ('green_tripdata_2020-01.csv','green_tripdata_2021-01.csv')
GROUP BY result.filename()
ORDER BY result.filename()

-- Use Filepath function
SELECT   
    result.filename() AS file_name,
    result.filepath() AS file_path,
    COUNT(1) AS record_counts
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv', 
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]
WHERE result.filename() IN ('green_tripdata_2020-01.csv','green_tripdata_2021-01.csv')
GROUP BY result.filename(), result.filepath()
ORDER BY result.filename(), result.filepath()

-- Filepath() - can take number - it refer the position of wild card character
-- For example:  BULK 'trip_data_green_csv/year=*/month=*/*.csv'
-- filepath(1) - year / filepath(2) - month / filepath(3) - file name
SELECT   
    result.filename() AS file_name,
    result.filepath(1) AS year,
    result.filepath(2) AS month,
    COUNT(1) AS record_counts
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv', 
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]
WHERE result.filename() IN ('green_tripdata_2020-01.csv','green_tripdata_2021-01.csv')
GROUP BY result.filename(), result.filepath(1), result.filepath(2)
ORDER BY result.filename(), result.filepath(1), result.filepath(2);

-- To get only Year Month and count
SELECT   
    result.filepath(1) AS year,
    result.filepath(2) AS month,
    COUNT(1) AS record_counts
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv', 
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]
GROUP BY result.filepath(1), result.filepath(2)
ORDER BY result.filepath(1), result.filepath(2);

--Use Filepath in WHERE clause
SELECT   
    result.filepath(1) AS year,
    result.filepath(2) AS month,
    COUNT(1) AS record_counts
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv', 
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]
WHERE result.filepath(1) = '2020' 
    AND result.filepath(2) IN ('06','07','08')
GROUP BY result.filename(), result.filepath(1), result.filepath(2)
ORDER BY result.filename(), result.filepath(1), result.filepath(2);
