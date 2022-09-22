-- use COPY Command
COPY INTO dwh.trip_data_green_agg_copy
FROM 'https://<DATALAKENAME>.dfs.core.windows.net/nyc-taxi-data/gold/trip_data_green_agg'
WITH
(
	FILE_TYPE = 'PARQUET'
	,MAXERRORS = 0
	,COMPRESSION = 'snappy'
	,AUTO_CREATE_TABLE = 'ON'
)
GO

SELECT TOP 100 * FROM dwh.trip_data_green_agg_copy
GO

-- https://learn.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=azure-sqldw-latest