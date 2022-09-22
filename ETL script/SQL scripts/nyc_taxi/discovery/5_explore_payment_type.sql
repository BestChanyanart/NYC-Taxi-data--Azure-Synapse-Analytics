USE nyc_taxi_discovery

-- 1. JSON_VALUE
--Reading data from JSON with Array 
--Step 1 - dealing with sub_type by specify Index
SELECT CAST(JSON_VALUE(jsonDoc, '$.payment_type') AS SMALLINT) AS payment_type,
    CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc[0].value') AS VARCHAR(15) ) payment_type_des_0,
    CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc[1].value') AS VARCHAR(15) ) payment_type_desc_1
    FROM OPENROWSET(
        BULK 'payment_type_array.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '1.0', --(optional)
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' -- new line(default)
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type;

-- 2. use OPENJSON function to explode the array
-- Step 1 
SELECT  *
    FROM OPENROWSET(
        BULK 'payment_type_array.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '1.0', --(optional)
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' -- new line(default)
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        payment_type SMALLINT,
        payment_type_desc NVARCHAR(MAX) AS JSON );

-- Step 2 - Use another CROSS APPLY to explode subtype
SELECT  *
    FROM OPENROWSET(
        BULK 'payment_type_array.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '1.0', --(optional)
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' -- new line(default)
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        payment_type SMALLINT,
        payment_type_desc NVARCHAR(MAX) AS JSON 
        )
    CROSS APPLY OPENJSON(payment_type_desc)
    WITH(
        sub_type SMALLINT,
        value VARCHAR(20)
    );

-- Step 3 - Select column and rename column
SELECT  payment_type, payment_type_desc_value
    FROM OPENROWSET(
        BULK 'payment_type_array.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '1.0', --(optional)
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' -- new line(default)
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        payment_type SMALLINT,
        payment_type_desc NVARCHAR(MAX) AS JSON 
        )
    CROSS APPLY OPENJSON(payment_type_desc)
    WITH(
        sub_type SMALLINT,
        payment_type_desc_value VARCHAR(20) '$.value'
    );
    