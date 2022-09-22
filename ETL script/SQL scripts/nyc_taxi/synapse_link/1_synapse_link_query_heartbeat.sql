IF (NOT EXISTS(SELECT * FROM sys.credentials WHERE name = 'synapse-cosmosdb'))
    CREATE CREDENTIAL [synapse-cosmosdb]
    WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = '<<SECRET>>'
GO

SELECT TOP 100 *
FROM OPENROWSET(​PROVIDER = 'CosmosDB',
                CONNECTION = 'Account=synapse-cosmosdb;Database=nyc-taxi-db',
                OBJECT = 'Heartbeat',
                SERVER_CREDENTIAL = 'synapse-cosmosdb'
) AS [Heartbeat]
