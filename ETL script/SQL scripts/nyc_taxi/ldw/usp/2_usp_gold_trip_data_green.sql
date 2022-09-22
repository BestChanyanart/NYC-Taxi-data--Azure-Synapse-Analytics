USE nyc_taxi_ldw
GO

-- Create Store Procedure for Trip Data Green (csv.) to Parquet with showed Year and Month
CREATE OR ALTER PROCEDURE gold.usp_gold_trip_data_green 
@year VARCHAR(4),
@month VARCHAR(2)
AS 
BEGIN

    DECLARE @create_sql_stmt NVARCHAR(MAX),  --create variable
            @drop_sql_stmt NVARCHAR(MAX)

    SET @create_sql_stmt = 
        'CREATE EXTERNAL TABLE gold.trip_data_green_' + @year + '_' + @month +
        ' WITH(
                DATA_SOURCE = nyc_taxi_src, 
                LOCATION = ''gold/trip_data_green/year=' + @year +'/month=' + @month + ''',
                FILE_FORMAT = parquet_file_format
            )
        AS 
        SELECT  td.year, 
            td.month, 
            tz.borough,
            CONVERT(DATE, td.lpep_pickup_datetime) AS trip_date,
            cal.day_name AS trip_day,
            CASE WHEN cal.day_name IN (''Saturday'', ''Sunday'') THEN ''Y'' ELSE ''N'' END AS trip_day_weekend_ind,
            SUM(CASE WHEN pt.description = ''Credit card'' THEN 1 ELSE 0 END) AS card_trip_count,
            SUM(CASE WHEN pt.description = ''Cash'' THEN 1 ELSE 0 END) AS cash_trip_count,
            SUM(CASE WHEN tt.trip_type_desc = ''street_hail'' THEN 1 ELSE 0 END) AS street_hail_trip_count,
            SUM(CASE WHEN tt.trip_type_desc = ''Dispatch'' THEN 1 ELSE 0 END) AS dispatch_trip_count,
            SUM(td.trip_distance) AS trip_distance,
            SUM(DATEDIFF(MINUTE, td.lpep_pickup_datetime, td.lpep_dropoff_datetime)) AS trip_duration,
            SUM(td.fare_amount) AS fare_amount
        FROM silver.vw_trip_data_green AS td
        JOIN silver.taxi_zone AS tz
            ON (td.pu_location_id = tz.location_id)
        JOIN silver.calendar AS cal
            ON (cal.date = CONVERT(DATE, td.lpep_pickup_datetime))
        JOIN silver.payment_type AS pt 
            ON(td.payment_type = pt.payment_type)
        JOIN silver.trip_type AS tt
            ON(td.trip_type = tt.trip_type)
        WHERE td.year = '''+ @year + '''
            AND td.month = '''+ @month + '''
        GROUP BY td.year, 
            td.month, 
            tz.borough,
            CONVERT(DATE, td.lpep_pickup_datetime),
            cal.day_name '
    print(@create_sql_stmt)
    EXEC sp_executesql @create_sql_stmt;   -- execute the variable @create_sql_stmt

    SET @drop_sql_stmt = 
    'DROP EXTERNAL TABLE gold.trip_data_green_' + @year + '_' + @month;

    print(@drop_sql_stmt)
    EXEC sp_executesql @drop_sql_stmt;   -- execute the variable @drop_sql_stmt

END;
