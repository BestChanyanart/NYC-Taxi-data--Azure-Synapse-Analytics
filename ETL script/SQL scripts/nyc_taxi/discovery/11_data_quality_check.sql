USE nyc_taxi_discovery

-- Identify any data quality issues in trip total amount 

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE = 'nyc_taxi_raw'
    ) AS [result]


-- Basic check
SELECT
    MIN(total_amount) AS min_total_amount,
    MAX(total_amount) AS max_total_amount,
    AVG(total_amount) AS avg_total_amount,
    COUNT(1) AS total_number_of_record,
    COUNT(total_amount) AS not_null_total_number_of_records
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE = 'nyc_taxi_raw'
    ) AS [result];
-- min got -210.3 It's look strange! 

-- Let's investigate
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE = 'nyc_taxi_raw'
    ) AS [result]
WHERE total_amount < 0;

-- It's show the Payment Type is 3 and 4 
-- What is it? Let's find from payment_type file
SELECT payment_type, description 
    FROM OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b'
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        payment_type SMALLINT,
        description VARCHAR(20) '$.payment_type_desc'
    );
-- payment type 3 means 'no charage' / 4 means 'dispute'(refund)

-- Let's check for whole data in Month=1 to check how many payment_type
SELECT
    payment_type,
    COUNT(1) AS number_of_records
FROM
    OPENROWSET(
        BULK 'trip_data_green_parquet/year=2020/month=01/',
        FORMAT = 'PARQUET',
        DATA_SOURCE = 'nyc_taxi_raw'
    ) AS [result]
GROUP BY payment_type
ORDER BY payment_type