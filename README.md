# NYC-Taxi-data--Azure-Synapse-Analytics

![Synapse Tool](https://user-images.githubusercontent.com/63108802/191794330-2383b89c-771e-4f3b-952f-7233a81c8124.PNG)

This is a part of Udemy course that I enrolled on Udemy. [Azure Synapse Analytics For Data Engineers-Hands On Project](https://www.udemy.com/course/azure-synapse-analytics-for-data-engineers) I'm interested in Azure for a year, and would like to deep dive into it more. So, I decided to take the course. Azure Synapse Analytics is a unified platform, where we can manage data from end to end. There are tools for Extract, Transform and Load within workspace. 

NYC Taxi Green is a dataset in this course, which collected from January 2020 to July 2021. Dataset comes with different file types, so we have to deal with ingesting those different types to Synapse workspace. 

![NYC taxi](https://user-images.githubusercontent.com/63108802/191794215-6b12b1c1-2d9d-4e62-b86e-36e3d446dd78.PNG)

---------------------------------------
## **Dataset**
 
[NYC dataset](https://drive.google.com/file/d/1Bx17np6cYdB7fZDR64aKgyHSfcKyhNVC/view?usp=sharing) 

Data was transformed to different file types, and we will deal with them in Synapse Workspace to Ingest, Tranform and Load data by using Serverless Pool:

**Dimension Table**
1. Taxi  Zone 
    - CSV file with header 
    - CSV file without header
2. Calendar
    - CSV file
3. Vendor
    - CSV file
    - CSV file with Escaped characters( \ )
    - CSV file with Unquote (" ") 
4. Rate Code
    - TSV, Tap Separated
5. Trip Type
    - JSON file 
6. Payment Type
    - JSON file 
    - JSON file with array 


**Fact Table**

7. Trip Data Green 
    - CSV file with Partitioned by Year and Month 
    - Parquet file with Partitioned by Year and Month 
    - Delta file with Partitioned by Year and Month 

![file type](https://user-images.githubusercontent.com/63108802/191794474-f733eb4c-2ac1-4e49-94b3-cf605c4f1e4c.PNG)

-----
## What is Serverless SQL Pool? 
We mainly use Serverless SQL Pool for doing ETL. 

Serverless SQL pool is a Serverless Distributed Query Engine that can use to query data over Datalake by T-SQL. Serverless SQL pool has no storage suppored, so it is the way to save the cost. Serverless SQL will charge when query (pay-per-use Model). When we run the query, It will go to Data Source and get the data from there, we can keep those data as an External Table in Serverless SQL Pool. 

Creating an External Table need to identfy 
   - External Data Source 
   - External File Format 
 
 Example: Using Taxi_Zone.csv file and Create External table in Serverless SQL Pool. 
 Using OPENROWSET() function to point out the Data Source and Identify File Format. We also specify Schema using WITH() clause. 
 
````

SELECT
    *
FROM
    OPENROWSET(
        BULK 'taxi_zone.csv',
        DATA_SOURCE = 'nyc_taxi_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH (
        LocationID   SMALLINT 1, 
        Borough      VARCHAR(15) 2, 
        Zone         VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    )AS [result]

````
Note: Specify Schema that fit to the data, it can reduce the query cost. 

----------------------------
## WorkFlow

![Serverless](https://user-images.githubusercontent.com/63108802/191794945-a1579a91-d86c-499e-abda-0d0ec53e53e7.PNG)

**Main Step**
1. Discovery ( Exploratory Data) with T-SQL 
2. Create External Table (Bronze Schema) - To ingest data and create External Table/View only, But we haven't transform it yet. 
3. Create External Table (Silver) - Transform data in an appropriate format 
4. Create External Table (Gold) - Join Table for using for an Analysis in PowerBII, or for keeping in Data Warehouse (Dedicated SQL Pool)
5. Create Pipeline and Schedule for run Trigger from Bronze to Gold

**Additional Step**
1. Transform data with Spark Pool (Notebooks) 
2. Query Data from Azure Cosmos DB (for Real-Time data, saving as JSON file) 
3. Provision Dedicated SQL Pool to keep Final data (Gold) 
4. Create Dashboard in PowerBI, connecting to Azure Synapse Analytics and publish to web
