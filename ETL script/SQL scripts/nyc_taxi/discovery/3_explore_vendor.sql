USE nyc_taxi_discovery

SELECT 
    *
    FROM OPENROWSET(
        BULK 'vendor_unquoted.csv',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS vendor;



    SELECT 
    *
    FROM OPENROWSET(
        BULK 'vendor_escaped.csv',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        ESCAPECHAR = '\\'
    ) AS vendor_es;

    SELECT 
    *
    FROM OPENROWSET(
        BULK 'vendor.csv',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDQUOTE = '"'
    ) AS vendor;

