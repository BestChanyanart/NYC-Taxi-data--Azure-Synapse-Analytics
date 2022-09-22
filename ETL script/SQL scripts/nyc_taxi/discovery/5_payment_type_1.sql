USE nyc_taxi_discovery

-- 1. JSON File (Single line)
-- Do not identify Parser_version and header_row for JSON file
-- Step 1. Read file JSON 
SELECT 
    *
    FROM OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '1.0', --(optional)
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' -- new line(default)
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type;


-- Step 2. Use JSON function: JSON_VALUE( json file , property )
SELECT JSON_VALUE(jsonDoc, '$.payment_type') AS payment_type,
        JSON_VALUE(jsonDoc, '$.payment_type_desc') payment_type_desc
    FROM OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '1.0', --(optional)
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' -- new line(default)
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type;

-- Step 3. Specify Type of data, Use CAST function
SELECT CAST(JSON_VALUE(jsonDoc, '$.payment_type') AS SMALLINT) AS payment_type,
        CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc') AS VARCHAR(15) ) payment_type_desc
    FROM OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '1.0', --(optional)
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0a' -- new line(default)
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type;

--JSON_VALUE function's limitation - It's is difficult to specify the data type, which we need to use CAST function
--JSON_VALUE function's limitation - If JSON file has an array - it can't explore an entire array.

-- 2. JSON File (Single line)
-- use OPENJSON function -- It's more powerful than JSON_VALUE
--Step 1: Use OPENJSON(JSONfile)
SELECT * 
    FROM OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b'
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS payment_type
    CROSS APPLY OPENJSON(jsonDoc);

--Step 2: Specify data type by using WITH clause
SELECT * 
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
        payment_type_desc VARCHAR(20)
    );

-- Step 3 Specify Column that we need in SELECT clause
SELECT payment_type, payment_type_desc 
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
        payment_type_desc VARCHAR(20)
    );

-- Step 4 Rename column name
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