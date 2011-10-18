# 1508 DEPLOYMENT UTILITY SCRIPTS
-------
Utilies used in the automated deployment of Developer environments.
At 1508 we develop Sitecore CMS and Umbraco solutions, all client solutions are hosted on our QA servers and deployed from there to the local dev machines with the help of these utility scripts.

We hope you can find help and inspiration in these utilities.
See the sample for inspiration.

1508 / Design in Love with Technology

----------


## Clean.QA.Solution.cmd

 Removes any files that are unnessesary for the solutions on a QA environment
 
   CLEAN.QA.SOLUTION [path to qa solution] 

   Removes/Cleans
   - MediaCache, Viewstate under ./Website/App_Data/
   - Sitecore ./Data/Serialized ./Data/Dump and log files under ./Data/
   - Backups located in root of ./Databases Backup (any backup subfolders are not touched)
   - Svn folders 
   - Code files not located under ./Website/App_Code, ./Website/Sitecore or ./Website/Umbraco
   - Empty folders under ./Website/Applicationcode



## Clean.QA.Solution.Projects.cmd

 Finds all project folders on QA solution drive and call CLEAN.QA.SOLUTION utility for each
 
   CLEAN.QA.SOLUTION.PROJECTS [path to qa solution root] 
 
   ex. clean.qa.solution.projects.cmd "s:"

   For each subfolder/Project removes/Cleans
   - MediaCache, Viewstate under ./Website/App_Data/
   - Sitecore ./Data/Serialized ./Data/Dump and log files under ./Data/
   - Backups located in root of ./Databases Backup (any backup subfolders are not touched)
   - Svn folders 
   - Code files not located under ./Website/App_Code, ./Website/Sitecore or ./Website/Umbraco
   - Empty folders under ./Website/Applicationcode



## FILE.permission.cmd

 Set ACL change access to the Network Service on the specified path
   
   FILE.permission.cmd [path]
   



## HELP.cmd

  Displays help.htm
   



## HELP.update.cmd

  Generates help.htm
   



## IIS5.create.cmd

 Setup XP IIS 5.1 default root to Website and run aspnetregiis

 IIS5.CREATE webroot aspnetframework_regiis_path

 webroot     Specifies the site path 
 aspnetframework_regiis_path
             Specifies the path to the framework regiis file

  Step 1:   Validate System
  Step 2:   Override Website Root
  Step 3:   Register Asp.Net with "aspnet_regiis -s w3svc" on all Sites,
            this overrides any custom asp.net site settings




## IIS6.create.cmd

  Creates IIS6 Website and App Pool

  IIS6.CREATE webroot hostheader webname appname aspnetframework_regiis_path

  webroot     Specifies the site path 
  hostheader  Specifies the hostheader names (will always bind to :80)
              Can be set empty and can set multiple by separating with comma
              (Will create a website with each hostheader)
  webname     Specifies the site name 
  appname     Specifies the name of the application pool to bind to
  aspnetframework_regiis_path
              Specifies the path to the framework regiis file


  Step 1:   Validate System
  Step 2:   Create Backup of IIS (can be restored in IIS Backup/Restore)
  Step 3:   Stop default website and sharepoint admin website (W3SVC/1 and /2) 
            Default webs are unsuitable for development and hosting.
  Step 4:   Create ApplicationPool 
  Step 5:   Create Website  () 
  Step 6:   Register Asp.Net with "aspnet_regiis -s w3svc" on all Sites,
            this overrides any custom asp.net site settings
 



## IIS7.create.cmd


  Creates IIS7 Website and App Pool

  IIS7.CREATE webroot hostheader webname appname aspnetframework_regiis_path managedPipelineMode bin

  webroot     Specifies the site path 
  hostheader  Specifies the hostheader names (will always bind to :80)
              Can be set empty and can set multiple by separating with comma
  webname     Specifies the site name 
  appname     Specifies the name of the application pool to bind to
  aspnetframework_regiis_path
              Specifies the path to the framework regiis file
  managedPipelineMode 
              Classic or Integrated (default is Classic)
  bin         Specifies the folder for the global script utilities

  Step 1:   Validate System
  Step 2:   Create Configuration Backup 
  Step 3:   If hostheader not provided Stops all other websites (W3SVC/x)
  Step 4:   Create ApplicationPool  
  Step 5:   Create Website  () 
  Step 6:   Set Framework version on Application Pool Site



## IISx.create.cmd

 Choose system and redirect parameters to valid IIS system.

   IISx.create WEBROOT HOSTHEADER WEBNAME APPNAME ASPNETFRAMEWORK_REGIIS_PATH (managedPipelineMode)

   HOSTHEADER           Can be comma separated but only IIS7 will interpret this. IIS6 will create separate websites for each hostheader
   managedPipelineMode  Used by IIS7, default is classic but "Integrated" can be set for the website app pool.

 Example:
 .\IISx.create.bat"  "D:\SDU776.0507\WebSite" "sdu.local,sdunet.local" "SDU776 SDU Intranet" "SDU776 AppPool" "C:\Windows\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe"




## IISx.vdir.cmd

 Creates a virtual directories 
  
 IISX.VDIR "" "" ""
 IISX.VDIR webname vdirname vdirroot

   webname   Specifies the website name 
   vdirname  Specifies the name of the virtual directory
   vdirroot  Specifies the path of the virtual directory




## MSSQL2008.init.cmd

 Enable Sql LoginMode and restarts MSSQLSERVER 
   
   MSSQL2008.init.cmd [login] [password]
   



## MSSQL2008.Master.RecoveryModes.cmd

 Set recovery mode simple on all database on specified server (except system database)
   
   MSSQL2008.Master.RecoveryModes.cmd [server] [login] [password]
   



## MSSQL2008.Master.ShrinkDatabases.cmd

 Shrink all databases on specified server (except system database)
   
   MSSQL2008.Master.ShrinkDatabases.cmd [server] [login] [password]
   



## NArrange.Source.cmd

 Arrange source code based on a visual studio project file
   
   Set as pre-build event:
   \\QA\utilities\Deployment\NArrange.Source.cmd "$(SolutionPath)"
   



## Remove Temporary ASP.NET Files.cmd

Removes temporary ASP.NET files




## SQL.attach.cmd

 Attach *.mdf and *.ldf files from disk
   
   SQL.attach.bat [server] [user] [password] [path] [ExpectedCount]



## SQL.backup.cmd

 Backup running databases with to disk
   
   SQL.backup.bat [server] [user] [password] [pattern] [path] 



## SQL.restore.cmd

 Restore databases from disk
   
   SQL.restore.bat [server] [user] [password] [path from] [path to] [ExpectedCount] ([Custom date format or *])



## sudo.cmd

 Provides a command line method of launching applications that prompt for elevation (Run as Administrator) on Windows Vista.
   
   sudo [command]



## SVN.checkout.cmd

 Check out SVN archive
   
   SVN.checkout.cmd [svn path] [path]



## SVN.export.cmd

 Export SVN archive
   
   SVN.export.cmd [svn path] [path]



## SVN.update.cmd

 Update SVN folder
   
   SVN.update.cmd [path]



## VS2005.build.cmd

  Build solution and start developer environment
   
   VS2005.build.cmd [solution filepath]



## VS2008.build.cmd

  Build solution and start developer environment
   
   VS2008.build.cmd [solution filepath]



## VS2010.build.cmd

  Build solution and start developer environment
   
   VS2010.build.cmd [solution filepath]



## wait.cmd

  Wait the amount of seconds before continuing
 
    WAIT [seconds]



----------

This Readme.md is generated with the HELP.update.cmd Script.
We hope you can find help and inspiration in these utilities.

The 1508 Development Team

