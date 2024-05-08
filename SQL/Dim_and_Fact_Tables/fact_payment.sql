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

CREATE EXTERNAL TABLE dbo.fact_payment
WITH (
    LOCATION     = 'fact_payment',
    DATA_SOURCE = [bikesharestoragelakefilesystem_bikesharestoragelake_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT 
p.payment_id,
p.rider_id,
p.amount,
p.date_id,

FROM [dbo].[staging_payment] p
JOIN [dbo].[staging_rider] ON rider_id = p.rider_id;
GO


SELECT TOP 100 * FROM [dbo].[fact_payment]
GO