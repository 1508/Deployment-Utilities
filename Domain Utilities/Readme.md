 ------------------------------------------------------------
# VMWARE SCRIPTS TO PREPARE CLONE 
 ------------------------------------------------------------
 CHANGELOG:

 2009-02-17 jhe@1508.dk	Created
 2011-10-06 jhe@1508.dk Released on 1508 Github
 -------------------------------------------------------------

 Utility for joining cloned Virtual Machines to domain without the local user having domain priviledges.

 ------------------------------------------------------------
# BUILD ENCRYPTED BATCH FILES
 ------------------------------------------------------------

 Build.bat is used for generating cpj files that contain the encrypted domain admin password. 
 The batch files use CRC checks any change to the files requires a re-encryption.

     >Build.bat 1508lan\vmware xxxxx
  Domain user with domain admin priviledges
 
 *.runtime.bat 
 The files contain the script for joining the domain and removing from the domain.
 The files have the parameters %1 %2, domain account og password

 *.cpj 
 The encrypted version of *.runtime.bat where domain account information is embedded.

 ------------------------------------------------------------
# JOIN 1508LAN.bat
 ------------------------------------------------------------

 When creating a new clone it must be made unique and joined to the domain. 
 Join.1508LAN.bat is run from the VM machines local admin account as a login job.
 This means the developer only needs to clone and login two times on the local admin account for being ready.

 1. Login to local administrator
 2. Startup Batch > Reset machine SID, saves to log and restart
 3. Login to local administrator
 4. Startup Batch > Joins the domain, saves to log and restart
 5. READY and joined to domain
      
 The batch job validates based on log files if step 2 and 4 have been run and just gives an ok state on later logins.

 ------------------------------------------------------------
# RESET CLONE.bat
 ------------------------------------------------------------
 
 Reset.Clone.bat can be used if you require removing the machine from the domain.

 1. Removes log files
 2. Removed domain information on the machine
 3. Restarts 

 The machine is then ready for running join.1508lan.bat at the next local admin login.

 ------------------------------------------------------------
# EXTERNAL UTILITIES
 ------------------------------------------------------------

 **netdom**
 Microsoft support tool for domain administration

 **newsid**
 Microsoft tool for generating new SID

 **psgetsid**
 Microsoft tool for reading current SID

 **CPAU**
 Utility used for encripting command line commands in a predefined user context

 ------------------------------------------------------------
 CLIENT TOOLS SETUP ON MAIN VM IMAGE
 ------------------------------------------------------------

 Contains the scripts that must be copied to a local folder on the VMware images e.g. "c:\VMware Utilities" 
 The *.runtime.bat files and the encrypted cpj files must be copied.
  
 The local Administrator on the Main VM image must have a start up link to join.1508lan.bat.

