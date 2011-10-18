/*
 * 2009-01-05 jhe@1508.dk
 * xp_cmdshell er en foruds�tning for at sql serveren kan tilg� filsystemet p� host.
 * Default setup er at den er disabled. 
 */ 

 
-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 0
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO
-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 0
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
