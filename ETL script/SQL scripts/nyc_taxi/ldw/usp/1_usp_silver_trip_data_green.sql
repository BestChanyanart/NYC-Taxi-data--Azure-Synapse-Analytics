USE nyc_taxi_ldw
GO

-- Create Store Procedure for Trip Data Green (csv.) to Parquet with showed Year and Month
CREATE OR ALTER PROCEDURE silver.usp_silver_trip_data_green 
@year VARCHAR(4),
@month VARCHAR(2)
AS 
BEGIN

    DECLARE @create_sql_stmt NVARCHAR(MAX),  --create variable
            @drop_sql_stmt NVARCHAR(MAX)

    SET @create_sql_stmt = 
        'CREATE EXTERNAL TABLE silver.trip_data_green_' + @year + '_' + @month +
        ' WITH(
                DATA_SOURCE = nyc_taxi_src, 
                LOCATION = ''silver/trip_data_green/year=' + @year +'/month=' + @month + ''',
                FILE_FORMAT = parquet_file_format
            )
        AS 
        SELECT * 
            FROM bronze.vw_trip_data_green_csv
            WHERE year = '''+ @year + '''
            AND month = '''+ @month + '''';
    print(@create_sql_stmt)
    EXEC sp_executesql @create_sql_stmt;   -- execute the variable @create_sql_stmt



    SET @drop_sql_stmt = 
    'DROP EXTERNAL TABLE silver.trip_data_green_' + @year + '_' + @month;

    print(@drop_sql_stmt)
    EXEC sp_executesql @drop_sql_stmt;   -- execute the variable @drop_sql_stmt

END;
