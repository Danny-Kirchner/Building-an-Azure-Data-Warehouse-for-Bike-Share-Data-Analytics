IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'bikesharestoragelakefilesytem_bikesharestoragelake_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [bikesharestoragelakefilesytem_bikesharestoragelake_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://bikesharestoragelakefilesytem@bikesharestoragelake.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.dim_date
WITH (
    LOCATION     = 'dim_date',
    DATA_SOURCE = [bikesharestoragelakefilesytem_bikesharestoragelake_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT 
ROW_NUMBER() OVER (ORDER BY Date) AS date_id,
        date,
        DATEPART(DAY, CONVERT(Date, Date)) AS DAY,
        DATEPART(MONTH, CONVERT(Date,Date)) AS MONTH, 
        DATEPART(QUARTER, CONVERT(Date,Date)) AS QUARTER,
        DATEPART(YEAR, CONVERT(Date,Date)) AS  YEAR,
        DATEPART(DAYOFYEAR,CONVERT(Date,Date)) AS DAY_OF_YEAR,
        DATEPART(WEEKDAY,CONVERT(Date,Date)) AS DAY_OF_WEEK
FROM dbo.staging_payment
GO


SELECT TOP 100 * FROM [dbo].[dim_date]
GO