USE nyc_taxi_discovery

-- Read JSON file that separated by 'comma', not new line as peviously
SELECT rate_code_id, rate_code 
    FROM OPENROWSET(
        BULK 'rate_code.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b' --vertical tab 'need to specify' for override newline
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS rate_code
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        rate_code_id TINYINT,
        rate_code VARCHAR(20)
    );

--- Process Multiple line JSON
SELECT rate_code_id, rate_code 
    FROM OPENROWSET(
        BULK 'rate_code_multi_line.json',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        FIELDTERMINATOR = '0x0b', --vertical tab
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b' --vertical tab 'need to specify' for override newline
    ) WITH(
        jsonDoc NVARCHAR(MAX)
    )AS rate_code
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        rate_code_id TINYINT,
        rate_code VARCHAR(20)
    );

