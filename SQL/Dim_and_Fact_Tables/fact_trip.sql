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

CREATE EXTERNAL TABLE dbo.fact_trip
WITH (
    LOCATION     = 'fact_trip',
    DATA_SOURCE = [bikesharestoragelakefilesystem_bikesharestoragelake_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT 
t.trip_id,
t.rider_id,
t.rideable_type,
t.start_station_id,
t.end_station_id,
t.start_at,
t.ended_at,
DATEDIFF(MINUTE, start_at,ended_at) as [duration_minutes],
DATEDIFF(DAY, birthday, start_at) / 365 AS rider_age,
FROM [dbo].[staging_trip] t
JOIN [dbo].[staging_rider] On rider_id = t.rider_id;
GO


SELECT TOP 100 * FROM [dbo].[fact_trip]
GO