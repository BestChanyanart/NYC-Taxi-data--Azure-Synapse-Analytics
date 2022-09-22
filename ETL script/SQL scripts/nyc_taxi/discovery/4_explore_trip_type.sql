USE nyc_taxi_discovery --database name

SELECT *
    FROM OPENROWSET(
        BULK 'trip_type.tsv',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'csv',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = '\t'
    ) AS trip_types