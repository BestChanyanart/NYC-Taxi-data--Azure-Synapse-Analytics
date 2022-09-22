# NYC-Taxi-data--Azure-Synapse-Analytics

![Synapse Tool](https://user-images.githubusercontent.com/63108802/191794330-2383b89c-771e-4f3b-952f-7233a81c8124.PNG)


This course is one of Udemy course: [Azure Synapse Analytics For Data Engineers-Hands On Project](https://www.udemy.com/course/azure-synapse-analytics-for-data-engineers) Azure Synapse Analytics is a unified platform, where we can manage data from end to end.

We use the NYC Taxi Green dataset which collected from January 2020 to July 2021, the dataset comes with different file types, so we have to deal with ingesting those different types to Synapse workspace. 

![NYC taxi](https://user-images.githubusercontent.com/63108802/191794215-6b12b1c1-2d9d-4e62-b86e-36e3d446dd78.PNG)

---------------------------------------
## **Dataset**
 
[NYC dataset](https://drive.google.com/file/d/1Bx17np6cYdB7fZDR64aKgyHSfcKyhNVC/view?usp=sharing) 

Data was transformed to different file types, and we will deal with them in Synapse Workspace to ingest / Tranform and Load data by using Serverless Pool:

![file type](https://user-images.githubusercontent.com/63108802/191794474-f733eb4c-2ac1-4e49-94b3-cf605c4f1e4c.PNG)

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

-----
![Serverless](https://user-images.githubusercontent.com/63108802/191794945-a1579a91-d86c-499e-abda-0d0ec53e53e7.PNG)


